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
sub PRINT_it{
 #
 my ($ID,$ivar,$file) = @_;
 #
 my $stdout = *STDOUT;
 if (not $file eq "stdlog") { 
  open $fh, '>>:encoding(UTF-8)', "$file" or die "Can't write '$file': $!";
  $stdout=$fh;
 }
 #
 print $stdout "@".$BIB[$ID][$ivar]->{TYPE}."{".$BIB[$ID][$ivar]->{KEY}.",\n";
 foreach my $var(keys %{$BIB[$ID][$ivar]}){
  if ($var eq "KEY") {next};
  if ($var eq "TYPE") {next};
  print $stdout "  $var \t = {$BIB[$ID][$ivar]{$var}},\n";
 }
 print $stdout "}\n";
 #
 if (not $file eq "stdlog") { close $fh or die "Can't close '$file': $!"};
 #
}
1;
