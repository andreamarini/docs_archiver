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
 print "\n";
 #
 for (my $i1 = 0; $i1 < $NBIB[0]; $i1 = $i1 + 1){
  #print "$i1\n";
  my $found=0;
  for (my $i2 = 0; $i2 < $NBIB[1]; $i2 = $i2 + 1){
    if ("$BIB[0][$i1]->{File}" eq "$BIB[1][$i2]->{File}") 
    {
      #print "$BIB[0][$i1]->{File} $BIB[1][$i2]->{File}\n";
      $found=$i2+1;
      break;
    }
  }
  if ($found) {
   #print "$i1=$found\n";
   undef $found;
  }else{
   $i3=$i1-1;
   &PRINT_it(0,$i1,"stdlog");
   #print " $i3 $BIB[0][$i1]->{File} not found\n";
  };
 }
 #
}
1;
