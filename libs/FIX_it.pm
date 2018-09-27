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
sub FIX_it{
 my ($ID) = @_;
 for (my $i1 = 0; $i1 < $NBIB[$ID]; $i1 = $i1 + 1){
  foreach my $var(keys %{$BIB[$ID][$i1]}){
   if (not $var eq "file") {next};
   $BIB[$ID][$i1]{$var} =~ s/home\/marini\/Desktop\/DATABASE\/PAPERS/$PAPERS_db/g;
   $BIB[$ID][$i1]{$var} =~ s/PAPERS/$PAPERS_db/g;
  }
 }
 #
}
1;
