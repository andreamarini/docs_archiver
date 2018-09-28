#!/usr/bin/perl
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
# Paths
$HOME=$ENV{"HOME"};
do "$HOME/.docs_archiver/src.pl";
do "$SRC/libs/MODULES.pl";
#
# Initialize
$version="0.1";
local $| = 1;
&UTILS_time($date,$time);
@BIB_TYPS = qw(Article Book Conference Misc Unpublished PhdThesis InCollection Other Manual abstract title InBook article);
#
print "\n Docs Archiver version $version ";
#
# CMD line
&OPTIONS();
#
my $len= length($view);
if ($len eq 0) {$view="yes"};
$len= length($group);
if ($len eq 0) {$group="yes"};
if ($out_bib_file  eq "press"     ) {
 $out_bib_file="/home/marini/Domande-Documenti/Personal/Letture/press.bib";
 $PAPERS_db="/home/marini/Domande-Documenti/Personal/Letture/DATABASE";
};
if (not $in_bib_file  and not $add) {$in_bib_file="/home/marini/Papers_and_Results/bibliography.bib"};
if (not $out_bib_file and     $add) {$out_bib_file="/home/marini/Papers_and_Results/bibliography.bib"};
#
# No input bib file? Create an empty one
#
if(not $in_bib_file and $pdf and $add)
{ 
 &EMPTY;
 print "\n\n";
 exit;
};
#
#
# Help
if($help or not $in_bib_file){ &usage };
#
# Dump in
#
if ($in_bib_file)  {&DUMP_it($in_bib_file,0)};
print "\n\n Read ".($NBIB[0])." entry(ies) from $in_bib_file\n";
#
# Dump out and add in
#
if ($out_bib_file and not $fix) {
 &DUMP_it($out_bib_file,1);
 print "\n\n Read ".($NBIB[1])." entry(ies) from $out_bib_file\n";
 &ADD_it;
}elsif ($add){
 &ADD_it;
}
#
# Repair 
#
if ($out_bib_file and $fix) {
 &FIX_it(0);
 &WRITE_the_bib($out_bib_file,0);
}
#
# VIEW
#
if ($view){
 print "\n\n";
 if ($group)
  {&VIEW_groups(0)}
 else
  {&VIEW};
}
#
print "\n\n";
#
exit;
#
