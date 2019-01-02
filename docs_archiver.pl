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
$version="1.0";
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
if ($out_bib_file  =~ /press/     ) {
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
 if (-f $pdf) {&EMPTY("$pdf")};
 if (-d $pdf) {
  chdir("$pdf");
  opendir (DIR, ".") or die $!;
  while (my $file = readdir(DIR)) {
   if (not $file =~ /.pdf/) {next};
   &EMPTY("$file");
  }
  $in_bib_file=$pdf;
  chdir("../");
 }
 print "\n\n";
};
#
# Help
if($help or (not $in_bib_file and not $pdf)){ &usage };
#
# Dump in
#
if ($in_bib_file) {
 if (-f $in_bib_file) {
  if ($pdf and -f $pdf) {&DUMP_bib($in_bib_file,$pdf,0,1)}
  if (not $pdf        ) {&DUMP_bib($in_bib_file,0,0,1)}
 }
 if (-d $in_bib_file) {
  opendir (DIR, $in_bib_file) or die $!;
  while (my $bib = readdir(DIR)) {
   if (not $bib =~ /.bib/) {next};
   $pdf_file = "$bib";
   $pdf_file =~ s/.bibtex/.pdf/g;
   $pdf_file =~ s/.bib/.pdf/g;
   if (    -f "$in_bib_file/$pdf_file") {&DUMP_bib("$in_bib_file/$bib","$pdf_file",0,0)};
   if (not -f "$in_bib_file/$pdf_file") {&DUMP_bib("$in_bib_file/$bib",0,0,0)};
  }
 }
};
print "\n\n Read ".($NBIB[0])." entry(ies) from $in_bib_file (in)\n";
#
# Dump out and add in
#
if ($out_bib_file and not $fix) {
 &DUMP_bib($out_bib_file,0,1,1);
 print "\n\n Read ".($NBIB[1])." entry(ies) from $out_bib_file (out)\n";
 &ADD_it;
}elsif ($add){
 &ADD_it;
}
#
# Repair 
#
if ($out_bib_file and $fix) {
 &FIX_it(0);
# &WRITE_the_bib($out_bib_file,0,1);
}
#
# VIEW
#
if ($group)
{
 print "\n";
 if (not $add) {&VIEW_groups(0)}
}
#
if ($view){
 print "\n\n";
 {&VIEW};
}
#
print "\n\n";
#
exit;
#
