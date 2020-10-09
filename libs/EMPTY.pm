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
sub EMPTY{
 my ($file) = @_;
 #
 if ($out_bib_file =~ /press/ and not $file =~/$date/ ) 
 {
  $new_pdf=$file;
  $new_pdf=~ s/.pdf/$date.pdf/g;
  $new_pdf=~ s/.PDF/$date.PDF/g;
  &command("mv \"$file\" \"$new_pdf\"");
  $file=$new_pdf;
 };
 $in_bib_file=$file;
 my $db="$in_bib_file".".db";
 $in_bib_file=~ s/.pdf/.bib/g;
 $in_bib_file=~ s/.PDF/.bib/g;
 #
 # Try first to extract the doi
 #
 if (not $in_DOI) {
  &command("pdftotext \"$file\" tmp.txt");
  my $infile_data = &read_file("tmp.txt");
  my @infile=split(/\n/,$infile_data);
  &command("rm -f tmp.txt");
  my $DOI=0;
  foreach (@infile) { 
   if ($_ =~ /DOI/) {
    $URL=(split(/: /,$_))[1];
    $DOI=1;
   };
  } 
 }else{
  $URL=$in_DOI;
  $DOI=1;
 }
 if ($DOI) {
  print "\n\n DOI found is:$URL\n\n";
  $result=&prompt("Is it ok (y/n/e(dit))?");
  if ("$result" eq "y") {
   &command("$SRC/tools/doi2bib \"$URL\" > $in_bib_file");
   &DUMP_bib($in_bib_file,$file,0,1);
  }elsif ("$result" eq "n"){ 
  }elsif ("$result" eq "e"){ 
   $URL=&prompt("DOI:");
   &command("$SRC/tools/doi2bib \"$URL\" > $in_bib_file");
   &DUMP_bib($in_bib_file,$file,0,1);
  }
 }else{ 
  print "\n DOI not found. Trying as arXive\n";
  # 
  # Trying with arXive
  if (not $BIB_is_ok) 
  { 
   my $arxive=$file;
   $arxive=~ s/.pdf//g;
   &command("$SRC/libs/arxive2bib.py \"$arxive\" > $in_bib_file"); 
   &DUMP_bib($in_bib_file,$file,0,1);
   $BIB[0][1]->{KEY}="$arxive";
  }
  if ($BIB[0][1]->{Title} =~ "Error")
  {
   print "\n\n arXive search failed. Switching to manual\n";
   foreach my $var(keys %{$BIB[0][1]}){
     delete($BIB[0][1]{$var});
   }
   $result=&prompt("Manual DOI (y/n)?");
   if ("$result" eq "y") {
    $URL=&prompt("DOI:");
    &command("$SRC/tools/doi2bib \"$URL\" > $in_bib_file");
    &DUMP_bib($in_bib_file,$file,0,1);
   }
  }
 }
 #
 # Is bib ok?
 #
 my $BIB_is_ok;
 if ($BIB[0][1]->{TYPE} and not $BIB[0][1]->{Title} =~ /Error/) 
 {
  $BIB[0][1]->{doi}=$URL;
  &WRITE_the_bib($in_bib_file,0,-1);
  $BIB_is_ok=1;
 }else{
  &command("rm -f $in_bib_file");;
 }
 #print " DOI not found. Switching to manual\n\n";
 #
 if ($BIB_is_ok) 
 {
  print "\n";
  &PRINT_it(0,1,"stdlog");
 }elsif (not -f $db){
  my @MANUAL_BIB_TYPS = qw(Book Manual Misc Other Unpublished PhdThesis Notes MasterThesis Article);
  print "\n\n Possible TYPES are:\n";
  for $typ (@MANUAL_BIB_TYPS)
  {
    print "\t(".lcfirst(substr($typ,0,2)).") $typ\n"; 
  }
  $result=&prompt("Which one?");
  if (not $out_bib_file =~ /press/ and not $result =~ "no" )
  {
   $BIB[0][1]->{volume}="none";
   $BIB[0][1]->{numpages}=" ";
   $BIB[0][1]->{journal}="";
   $BIB[0][1]->{doi}="DOI";
   $BIB[0][1]->{month}="MONTH ";
   $BIB[0][1]->{url}="URL";
   $BIB[0][1]->{issue}="ISSUE";
   $BIB[0][1]->{pages}="PAGES ";
   $BIB[0][1]->{TYPE}="article";
  }
  $BIB[0][1]->{KEY}="$file";
  $BIB[0][1]->{KEY}=~ s/.file//g;
  $BIB[0][1]->{KEY}=~ s/.PDF//g;
  $BIB[0][1]->{timestamp}="$date";
  $BIB[0][1]->{year}="$current_year";
  if (not $results == "no" )
  {
   $BIB[0][1]->{publisher}=" ";
   $BIB[0][1]->{journal}=" ";
  }
  $BIB[0][1]->{author}=" ";
  $BIB[0][1]->{title}=$BIB[0][1]->{KEY};
  $BIB[0][1]->{title}=~ s/_/ /g;
  $BIB[0][1]->{title}=~ s/-/ /g;
  $NBIB[0]=1;
  #
  if ($result =~ "no") {$result="un"};
  #
  for $typ (@MANUAL_BIB_TYPS)
  {
   if (lcfirst(substr($typ,0,3)) =~ $result) {$BIB[0][1]->{TYPE}=$typ}
   elsif (lcfirst(substr($typ,0,2)) =~ $result) {$BIB[0][1]->{TYPE}=$typ}
   elsif (lcfirst(substr($typ,0,1)) =~ $result) {$BIB[0][1]->{TYPE}=$typ}
   #print "$result $BIB[0][1]->{TYPE}".lcfirst(substr($typ,0,2))."\n";
  }
  my $title=latex_encode($BIB[0][1]->{title});
  $BIB[0][1]->{title}=$title;
  $BIB[0][1]->{title}=~ s/'/\'/g;
  open $fh, '>', "$db" ;
  print $fh Dumper $BIB[0][1];
  close $fh;
  &command("vim \"$db\"");
 }
 if (-f $db) {
  open my $fh, '<', "$db" ;
  my $vars;
   { local $/ = undef; $vars = <$fh>; }
   $BIB[0][1]= eval $vars;
  close $fh;
  &PRINT_it(0,1,"$in_bib_file");
 }
}
1;
