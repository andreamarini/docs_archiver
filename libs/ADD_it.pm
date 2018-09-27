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
sub ADD_it{
 #
 my $result;
 my @founds;
 my @matches;
 my $to_add=0;
 print "\n BIB entries to be added\n\n";
 if ($key) 
 {
  @founds=&FIND_bib_element_using_KEY(0,$key);
 }
 #
 for (my $i1 = 1; $i1 <= $NBIB[0]; $i1 = $i1 + 1){
  my $if1=&FIND_bib_element_using_VAL(1,"Doi","$BIB[0][$i1]->{Doi}");
  my $if2=&FIND_bib_element_using_VAL(1,"Title","$BIB[0][$i1]->{Title}");
  if (    $key) {@matches = grep { /\b$i1\b/ } @founds};
  if (not $key) {@matches = qw(1)};
  if (not $if1 and not $if2 and @matches){
   &PRINT_it(0,$i1,"stdlog");
   $result=&prompt_yn("Add this entry?");
   if ($result eq "y") 
   {
    $to_add=1;
    $NBIB[1]=$NBIB[1]+1;
    %{$BIB[1][$NBIB[1]]}= %{$BIB[0][$i1]};
   }
  };
 }
 #
 if ($to_add) {&WRITE_the_bib(1)};
 #
}
1;
