#!/usr/bin/env perl

# David Griffith <davidgriffith@acm.org>
# isbn2bib version 0.4
# Copyright December 11, 2010
#

use strict;
use warnings;

use Getopt::Long qw(:config no_ignore_case);

use encoding "utf8";
use Text::BibTeX;
use WebService::ISBNDB::API::Books;
use Business::ISBN;
use Pod::Usage;

my $api_key = $ENV{ISBNDB_KEY} || 'KEY_GOES_HERE';
my %options;

GetOptions('usage|?' => \$options{usage},
	'h|help' => \$options{help},
 	'v|verbose' => \$options{verbose},
	'q|quiet' => \$options{quiet},
	'o|output-file=s' => \$options{outputfile},
	'e|error-file=s' => \$options{errorfile},
	'n|number=s' => \$options{number}
	);

pod2usage(1) if $options{usage};
pod2usage(-verbose => 2) if $options{help};


my $infile = shift;
my $outfile;

if ($options{quiet}) {
	open STDERR, '>/dev/null';
} else {
	if ($options{errorfile}) {
	open STDERR, ">$options{errorfile}";
	}
}

if ($options{outputfile}) {
	$outfile = $options{outputfile};
} else {
	$outfile = "/dev/stdout";
}

if (!$infile && !$options{number}) { pod2usage(1);}


# Weeds out blank lines, and invalid ISBN numbers.
# Invalid numbers and garbage are printed to STDERR

if ($options{verbose}) {
	if ($options{number}) {
		print "Getting ISBN data on $options{number}\n";
	} else {
		print "Reading ISBN numbers from $infile\n";
	}

	if (!$outfile) {
		print "Writing ISBN information to standard output.\n";
	} else {
		print "Writing ISBN information to $outfile\n";
	}
}

if ($infile) {
	open(INFILE, "<$infile");
}

my $entry;

my $bib = Text::BibTeX::File->new('>'.$outfile);

my $book_count = 1;


if ($options{number}) {
	lookup($options{number});
} else {
	while (<INFILE>) {
		lookup($_);
	}
	close(INFILE);
}



sub lookup {
	my ($input, @junk) = @_;
	my $book;

	if ($options{verbose}) {
		print "Processing line $book_count\n";
	}
	$book_count++;

	chomp($input);
	if ($input =~ /^$/) { 
		next;
	}
	($input, @junk) = split(/\s+/, $input);

	my $isbn = Business::ISBN->new("$input");
	if (! $isbn) {
		print STDERR "Rejected $input: Garbage.\n";
		next;
	}
	if (!$isbn->is_valid) {
		print STDERR "Rejected $input: ". 
			$Business::ISBN::ERROR_TEXT{$isbn->error}.
			".\n";
		next;
	}

	$book = WebService::ISBNDB::API::Books->find( {
		api_key => $api_key, isbn => $isbn->as_string});

	if (!$book) {
		print STDERR "Rejected $input: ",
			"Null reply from server.\n";
		next;
	}

	# make a new bibtex entry
	my $entry = new Text::BibTeX::Entry;
	$entry->set_metatype(BTE_REGULAR);
	$entry->set_type('book');
	$entry->set_key($isbn->as_string);

	# set title field
	$entry->set('title', $book->get_longtitle || $book->get_title);

	# set author or editor field
	my $authors = $book->get_authors_text;
	# some clean-up
	$authors =~ s/^by //;
	$authors =~ s/,$//;
	$authors =~ s/,\s+/ and /g;
	$authors =~ s/;\s+/ and /g;
	# authors or editors ?  
	if ( $authors =~ /^\s*\[?edited by\s+\]?(.*)$/i ) {
		(my $editors = $1) =~ s/with/and/;
		$entry->set('editor', $editors);
	}
	elsif ( $authors =~ /\(Editor\)/i ) {
		$authors =~ s/\s*\(Editor\)//gi;
	}
	else {
		$entry->set('author', $authors);
	}

	# parse publisher and edition fields for publisher and year data
	if ( $book->get_publisher_text =~ m/^(.*?),\s+c?(\d{4}).?$/ ) {
		$entry->set( 'publisher', $1 ) ;
		$entry->set( 'year', $2 );
	}
	else {
		$entry->set( 'publisher', $book->get_publisher_text ) ;
		if ( $book->get_edition_info =~ m/(\d{4})/ ) {
			$entry->set( 'year', $1 );
		}    
	}

	$entry->set( 'isbn', $isbn->as_string);

	# miscellaneous fields
	my $notes = $book->get_notes;
	$entry->set( 'notes', $notes ) if $notes ;

	my $abstract = $book->get_summary;
	$entry->set( 'abstract', $abstract ) if $abstract ;

	$entry->write($bib);

}



# Add escapes to characters with special meaning in TeX and LaTeX.
#
sub cleanup {
	my ($mystring, @junk) = @_;

	

}


__END__


=head1 NAME

isbn2bib.pl - Convert a list of ISBN numbers to BibTeX records

=head1 SYNOPSIS

isbn2bib.pl [options...] [inputfile] [outputfile]

Use -h or --help for verbose help.

=head1 DESCRIPTION

Reads ISBN numbers from a file, checks them for validity, fetches the 
corresponding data from isbndb.com, then outputs a BibTeX file with all 
fields set accordingly.  An API key from isbndb.com is required; see 
NOTES below.

=head2 Option flags

  -?			Print simple usage message.
  -h --help		Verbose help message.
  -q --quiet		Don't say anything, even if there's an error.
  -v --verbose		Be more chatty about what's going on.
  -n N			Look up just this ISBN number and output
  --number N		  a corresponding BibTeX entry.
  -o outfile		Write BibTeX entries to the file named.
  --output-file outfile
  -e errfile		Write error messages to the file named.
  --error-file errfile

=head1 APPLICATION

This script may be run on a text file containing a list of ISBN numbers, 
a single ISBN number supplied on the command line, or from a pipe.  When 
accepting ISBN numbers from a pipe, this script will emit a single beep
for a successful lookup and double beep for a failed lookup.  This
allows for immediate feedback when using a barcode scanner.

=head2 Examples

For a text file containing ISBN numbers:
    isbn2bib isbn-numbers.txt output.bib

For use with a barcode scanner:
    cat | isbn2bib -- output.bib

Now, make sure the xterm on which this script is running has focus,
then scan an ISBN barcode.  Press Control-C to stop this.

=head1 NOTES

An API key is required to access isbndb.com services.  To get one, use a 
web browser to visit http://isbndb.com/ and create a new account.  You 
can do up to 500 lookups per day gratis.  


You can either paste it in the source code or set the environment
variable ISBNDB_KEY.

This script is heavily based on i-blis's script for parsing PDF file 
names for ISBN-10 numbers.

Version 0.4

December 11, 2010

=head1 LICENSE

Free to use and modifiy, same terms as Perl itself.  This needs expansion.

=head1 AUTHOR

David Griffith <davidgriffith@acm.org>

=cut
