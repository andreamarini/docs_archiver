#
#        Copyright (C) 2000-2020 the YAMBO team
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
#
# Symbols fix
#
if ( $fix eq "titles" ) 
{
for (my $i1 = 0; $i1 < $NBIB[$ID]; $i1 = $i1 + 1){
  if ($BIB[$ID][$i1]->{title} =~ /textlangle/) 
  {
    $title=$BIB[$ID][$i1]->{title};
    print "\n $title\n";
    $title =~ s/\\textlanglei//g;
    $title =~ s/\\textlanglemi//g;
    $title =~ s/\\textlanglemath//g;
    $title =~ s/\\textlangle//g;
    $title =~ s/\\textrangle//g;
    $title =~ s/mrow//g;
    $title =~ s/msub//g;
    $title =~ s/\ mi//g;
    $title =~ s/\ mn//g;
    $title =~ s/\/mi//g;
    $title =~ s/\/i/ /g;
    $title =~ s/\/mn//g;
    $title =~ s/math\ display//g;
    $title =~ s/math//g;
    $title =~ s/\///g;
    print "=> $title\n";
    $BIB[$ID][$i1]->{title}=$title;
  }
}
}
#
if ( $fix eq "groups" ) 
{
for (my $i1 = 1; $i1 < $NBIB[$ID]; $i1 = $i1 + 1){
 $groups=$BIB[$ID][$i1]->{groups};
 if ($groups eq "") {
  print ("Title: $BIB[$ID][$i1]->{title}\n");
  $result=&prompt("EMPTY groups. Enter new group:");
  $BIB[$ID][$i1]->{groups}=$result;
 };
 if ($groups =~ /Time-Resolved/) {
  @GS=split(/,/,$groups);
  if ($#GS > 0) { 
   print "OLD $BIB[$ID][$i1]->{groups}\n";
   $BIB[$ID][$i1]->{groups}="";
   foreach(@GS)
   {
     if (not $_  =~ /Time-Resolved/ ) { $BIB[$ID][$i1]->{groups}.="$_,"};
   }
  };
  print "NEW $BIB[$ID][$i1]->{groups}\n";
 }
}
}

#
# for (my $i1 = 0; $i1 < $NBIB[$ID]; $i1 = $i1 + 1){
#  foreach my $var(keys %{$BIB[$ID][$i1]}){
#   if (not $var eq "file") {next};
#   $BIB[$ID][$i1]{$var} =~ s/home\/marini\/Desktop\/DATABASE\/PAPERS/$PAPERS_db/g;
#   $BIB[$ID][$i1]{$var} =~ s/PAPERS/$PAPERS_db/g;
#  }
# }
 #
# opendir (DIR, "/home/marini/Papers_and_Results/DATABASE") or die $!;
# while (my $pdf = readdir(DIR)) {
#  undef $found;
#  $PDF_ori=$pdf;
#  for (my $i1 = 0; $i1 < $NBIB[$ID]; $i1 = $i1 + 1){
#   $bib=$BIB[$ID][$i1]->{file};
#   $bib =~ s/\:\/home\/marini\/Papers_and_Results\/DATABASE\///g;
#   $bib =~ s/\:DATABASE\///g;
#   $bib =~ s/\:djvu//g;
#   $bib =~ s/\:Djvu//g;
#   $bib =~ s/\:PDF//g;
#   $bib =~ s/\s/_/g;
#   $pdf =~ s/\s/_/g;
#   $bib =~ s/\(/_/g;
#   $pdf =~ s/\(/_/g;
#   $bib =~ s/\)/_/g;
#   $pdf =~ s/\)/_/g;
#   $bib =~ s/\,/_/g;
#   $pdf =~ s/\,/_/g;
#   if ("$bib"=~"$pdf") {$found=$i1};
#   if ($found) {last};
#  }
#  if (!$found) {
#   print "$PDF_ori not found\n";
#   #&command("mv \"DATABASE/$PDF_ori\" TOCHECK");
#  };
# }
}
1;
