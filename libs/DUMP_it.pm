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
 my @TYPES = qw(Article Book Conference Misc Unpublished PhdThesis InCollection Other Manual Comment abstract title InBook);
 #
 my $infile_data;
 my $ic=-1;
 my $new_entry=0;
 print "\n\n";
 $infile_data = &read_file($bib_file);
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
    #print "$ivar $TYP $infile[$ivar] \n";
    next};
   $ic=$ic+1;
   $new_entry=1;
   $BIB[$ic]->{TYPE}=$TYP;
   #print "$ic $BIB[$ic]->{TYPE} @matches\n";
  }
  #
  if (substr("$infile[$ivar]",0,1) =~ "}") {undef $new_entry};
  #
  if ($new_entry)
  {
    if ("$infile[$ivar]" =~ "= {"){
     $FIELD=(split('\s+',$infile[$ivar]))[1];
     $VAL=(split('\=',$infile[$ivar]))[1];
    };
    print "$ic |$FIELD|$VAL| $infile[$ivar]\n";
  }
  #
 }
}
1;
