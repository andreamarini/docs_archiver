#
#        Copyright (C) 2000-2018 the YAMBO team
#              http://www.yambo-code.org
#
# Authors (see AUTHORS file for details): AM
#
# This file is distributed under the terms of the GNU
# General Public License. You can redistribute it and/or
# modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation;
# either version 2, or (at your option) any later version.
#
# This program is distributed in the hope that it will
# be useful, but WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public
# License along with this program; if not, write to the Free
# Software Foundation, Inc., 59 Temple Place - Suite 330,Boston,
# MA 02111-1307, USA or visit http://www.gnu.org/copyleft/gpl.txt.
#
sub EMPTY{
 my ($file) = @_;
 $in_bib_file=$file;
 my $db="$in_bib_file".".db";
 $in_bib_file=~ s/.pdf/.bib/g;
 $in_bib_file=~ s/.PDF/.bib/g;
 #
 # Try first to extract the doi
 #
 &command("pdftotext \"$file\" tmp.txt");
 my $infile_data = &read_file("tmp.txt");
 my @infile=split(/\n/,$infile_data);
 &command("rm -f tmp.txt");
 my $DOI=0;
 foreach (@infile) { 
  if ($_ =~ /DOI/) {
   $URL=(split(/: /,$_))[1];
   $DOI=1;
  };
 } 
 if ($DOI) {
  print "\n\n DOI found is:$URL\n\n";
  $result=&prompt("Is it ok (y/n/edit)?");
  if ("$result" eq "y") {
   &command("$SRC/tools/doi2bib \"$URL\" > $in_bib_file");
   &DUMP_bib($in_bib_file,$file,0,1);
   $BIB[0][1]->{doi}=$URL;
   &WRITE_the_bib($in_bib_file,0,-1);
  }elsif ("$result" eq "n"){ 
  }else{
   $URL="$result";
   &command("$SRC/tools/doi2bib \"$URL\" > $in_bib_file");
   &DUMP_bib($in_bib_file,$file,0,1);
   $BIB[0][1]->{doi}=$URL;
   &WRITE_the_bib($in_bib_file,0,-1);
  }
 }else{ 
  print "\n\n DOI not found\n";
  $result=&prompt("Manual DOI (y/n)?");
  if ("$result" eq "y") {
   $URL=&prompt("DOI:");
   &command("$SRC/tools/doi2bib \"$URL\" > $in_bib_file");
   &DUMP_bib($in_bib_file,$file,0,1);
   $BIB[0][1]->{doi}=$URL;
   &WRITE_the_bib($in_bib_file,0,-1);
  }
 }
 #
 if (-f $in_bib_file) 
 {
  print "\n";
  &PRINT_it(0,1,"stdlog");
 }elsif (not -f $db){
  $BIB[0][1]->{TYPE}="article";
  $BIB[0][1]->{KEY}="$file";
  $BIB[0][1]->{KEY}=~ s/.file//g;
  $BIB[0][1]->{KEY}=~ s/.PDF//g;
  $BIB[0][1]->{timestamp}="$date";
  $BIB[0][1]->{volume}="none";
  $BIB[0][1]->{year}=" ";
  $BIB[0][1]->{numpages}=" ";
  $BIB[0][1]->{doi}=" ";
  $BIB[0][1]->{publisher}=" ";
  $BIB[0][1]->{author}=" ";
  $BIB[0][1]->{month}=" ";
  $BIB[0][1]->{url}=" ";
  $BIB[0][1]->{issue}=" ";
  $BIB[0][1]->{journal}=" ";
  $BIB[0][1]->{title}=$BIB[0][1]->{KEY};
  $BIB[0][1]->{title}=~ s/_/ /g;
  $BIB[0][1]->{title}=~ s/-/ /g;
  $BIB[0][1]->{pages}=" ";
  $NBIB[0]=1;
  @BIB_TYPS = qw(Book Manual Misc Other Unpublished PhdThesis);
  print "\n\n Possible TYPES are:\n";
  for $typ (@BIB_TYPS)
  {
    print "\t(".lcfirst(substr($typ,0,2)).") $typ\n"; 
  }
  $result=&prompt("Which one?");
  for $typ (@BIB_TYPS)
  {
   if (lcfirst(substr($typ,0,2)) =~ $result) {$BIB[0][1]->{TYPE}=$typ}
   elsif (lcfirst(substr($typ,0,1)) =~ $result) {$BIB[0][1]->{TYPE}=$typ}
   #print "$result $BIB[0][1]->{TYPE}\n";
  }
  open $fh, '>', "$db" ;
  print $fh Dumper $BIB[0][1];
  close $fh;
  &command("vim \"$db\"");
 }
 if (-f $db) {
  open my $fh, '<', "$db" ;
  my $vars;
   { local $/ = undef; $vars = <$fh>; }
   $BIB[0][1]= eval $vars;
  close $fh;
  &PRINT_it(0,1,"$in_bib_file");
 }
}
1;
