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
sub WRITE_the_bib{
 #
 my $file=$out_bib_file;
 #
 &command("cp    $out_bib_file $out_bib_file.SAVE");
 &command("rm -f $out_bib_file");
 #
 open $fh, '>>', "$file" or die "Can't write '$file': $!";
 print $fh "% Encoding: UTF-8\n";
 close $fh or die "Can't close '$file': $!";
 #
 my ($ID) = @_;
 for (my $i1 = 1; $i1 <= $NBIB[$ID]; $i1 = $i1 + 1){
  &PRINT_it($ID,$i1,$file);
 }
 open $fh, '>>', "$file" or die "Can't write '$file': $!";
 for (my $i1 = 0; $i1 <= $NCOMMENT[1]; $i1 = $i1 + 1){
  print  $fh $COMMENT[1][$i1]
 }
 print $fh "\n\@Comment{jabref-meta: groupstree:\n0 AllEntriesGroup:;";
 for (my $i1 = 0; $i1 < $NGRP[1]; $i1 = $i1 + 1){
  print $fh  "\n$GRP[1][$i1]->{LEVEL} ExplicitGroup:$GRP[1][$i1]->{NAME}\\;0\\;;";
 }
 print $fh  "\n}";
 close $fh or die "Can't close '$file': $!";
 #
}
1;
