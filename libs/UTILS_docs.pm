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
#
sub FIND_bib_element_using_VAL{
 ($ID,$VAR,$VAL)=@_;
 my $found=0;
 for (my $i1 = 0; $i1 < $NBIB[$ID]; $i1 = $i1 + 1){
  foreach my $V1(keys %{$BIB[$ID][$i1]}){
   if ("$VAR" eq "$V1" and "$VAL" eq "$BIB[$ID][$i1]{$V1}") {
    $found=$i1+1;
   }
  }
  if ($found) {break};
 }
 #
 return $found;
 #
}
sub FIND_bib_element_using_KEY{
 ($ID,$KEY)=@_;
 my $found;
 my @founds;
 my @keys=split(',',$KEY);
 for (my $i1 = 0; $i1 < $NBIB[$ID]; $i1 = $i1 + 1){
  $found=0;
  foreach my $V1(keys %{$BIB[$ID][$i1]}){
   foreach my $local_key (@keys){
    if ("$V1" =~ /$local_key/i or "$BIB[$ID][$i1]{$V1}" =~ /$local_key/i) {
     $found=$i1;
     break;
    }
   }
  }
  if ($found) {push @founds, $found};
 }
 #
 return @founds;
 #
}
sub VIEW{
 my @founds;
 if ($key) {
  @founds=&FIND_bib_element_using_KEY(0,$key);
  foreach my $if (@founds)
  {
   &PRINT_it(0,$if,"stdlog");
  }
 }else{ 
  for (my $if = 1; $if <= $NBIB[0]; $if = $if + 1){
   &PRINT_it(0,$if,"stdlog");
  }
 }
 exit;
}
1;
