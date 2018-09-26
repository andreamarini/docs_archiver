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
sub DUMP_it{
 #
 my ($file,$ID) = @_;
 #
 my @TYPES = qw(Article Book Conference Misc Unpublished PhdThesis InCollection Other Manual Comment abstract title InBook comment);
 my @FIELDS = qw(author title journal year volume pages file groups);
 #
 if ($dump) { open $fh, '>', "$file".".db" or die "Can't write '$file' db: $!"};
 #
 my $infile_data;
 my $ic=-1;
 my $new_entry=0;
 $infile_data = &read_file($file);
 my @infile=split(/\n/,$infile_data);
 my $size = scalar @infile;
 for ($ivar = 0; $ivar < $size; $ivar = $ivar + 1){
  #
  if (substr("$infile[$ivar]",0,1) =~ "@") {
   $infile[$ivar] =~ s/@/ /g; 
   $infile[$ivar] =~ s/{/ /g; 
   $TYP=(split(" ",$infile[$ivar]))[0];
   chomp($TYP);
   my @matches = grep { /$TYP/ } @TYPES;
   if (!@matches){
    print "TYPR $TYP unlisted \n";
    next};
   $ic=$ic+1;
   $new_entry=1;
   $BIB[$ID][$ic]->{TYPE}=$TYP;
   $BIB[$ID][$ic]->{KEY}=(split('\s+',$infile[$ivar]))[2];
   $BIB[$ID][$ic]->{KEY} =~ s/,//g; 
   #print "$ic |TYP|$BIB[$ID][$ic]->{TYPE}\n";
   #print "$ic |KEY|$BIB[$ID][$ic]->{KEY}\n";
  }
  #
  if (substr("$infile[$ivar]",0,1) =~ "}") 
  {
   if ($dump) {print $fh Dumper $BIB[$ID][$ic]};
   undef $new_entry;
  };
  #
  if ($new_entry)
  {
    if ("$infile[$ivar]" =~ "="){
     $FIELD=(split('\s+',$infile[$ivar]))[1];
     $FIELD=ucfirst "$FIELD" ;
     $VAL=(split('\=',$infile[$ivar]))[1];
     $VAL =~ s/{//g;
     $VAL =~ s/},//g;
     $VAL =~ s/}//g;
     #substr ($VAL,0,2)=" ";
     #substr ($VAL,-2,2)=" ";
     $VAL =~ s/^\s+|\s+$//g;
     $BIB[$ID][$ic]->{$FIELD}=$VAL;
     #print "$ic |$FIELD|$BIB[$ID][$ic]->{$FIELD}\n";
    };
  }
  #
 }
 $NBIB[$ID]=$ic;
 if ($dump) {close $fh or die "Can't close '$file': $!"};
}
1;
