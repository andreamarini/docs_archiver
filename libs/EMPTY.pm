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
 # remove spaces and strange characters
 #
 $new_pdf=$file;
 $new_pdf=~ s/ /_/g;
 $new_pdf=~ s/,/_/g;
 &command("mv \"$file\" \"$new_pdf\"");
 $file=$new_pdf;
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
 $NBIB_try=$NBIB[0]+1;
 #
 # Try first to extract the doi
 #
 if (not $in_DOI) {
  &command("pdftotext \"$file\" tmp.txt");
  $infile_data = &read_file("tmp.txt");
  @infile_n=split(/\n/,$infile_data);
  @infile_s=split(/\n/,$infile_data);
  &command("rm -f tmp.txt");
  undef $DOI;
  foreach (@infile_n) { 
   if ($_ =~ /DOI/) {
    $URL=(split(/: /,$_))[1];
    $DOI=1;
    last;
   };
  }
  if (not $DOI) {
   foreach (@infile_s) { 
    if ($_ =~ /doi.org/) {
     $URL=(split(/doi.org\//,$_))[1];
     $URL=(split(/ /,$URL))[0];
     $DOI=1;
     last;
    };
   }
  }
 }else{
  $URL=$in_DOI;
  $DOI=1;
 }
 if ($DOI) {
  print "\n\n DOI found for $file is:$URL\n\n";
  $result=&prompt("Is it ok (y/n/e(dit))?");
  if ("$result" eq "y") {
   &command("$SRC/tools/doi2bib \"$URL\" > $in_bib_file");
   &DUMP_bib($in_bib_file,$file,0,$SCAN_dir);
  }elsif ("$result" eq "n"){ 
  }elsif ("$result" eq "e"){ 
   $URL=&prompt("DOI:");
   &command("$SRC/tools/doi2bib \"$URL\" > $in_bib_file");
   &DUMP_bib($in_bib_file,$file,0,$SCAN_dir);
  }
 }else{ 
  $result=&prompt("\n DOI not found. Trying as arXive using $file?");
  # 
  # Trying with arXive
  if (not $BIB_is_ok and "$result" eq "y") 
  { 
   my $arxive=$file;
   $arxive=~ s/.pdf//g;
   &command("$SRC/libs/arxive2bib.py \"$arxive\" > $in_bib_file"); 
   &DUMP_bib($in_bib_file,$file,0,$SCAN_dir);
   $BIB[0][$NBIB_try]->{KEY}="$arxive";
  }else{
   $BIB[0][$NBIB_try]->{Title} = "Error";
  }
  if ($BIB[0][$NBIB_try]->{Title} =~ "Error")
  {
   print "\n\n arXive search failed. Switching to manual\n";
   foreach my $var(keys %{$BIB[0][$NBIB_try]}){
     delete($BIB[0][$NBIB_try]{$var});
   }
   $result=&prompt("Manual DOI (y/n)?");
   if ("$result" eq "y") {
    $URL=&prompt("DOI:");
    &command("$SRC/tools/doi2bib \"$URL\" > $in_bib_file");
    &DUMP_bib($in_bib_file,$file,0,$SCAN_dir);
   }
  }
 }
 #
 # Is bib ok?
 #
 my $BIB_is_ok;
 if ($BIB[0][$NBIB_try]->{TYPE} and not $BIB[0][$NBIB_try]->{Title} =~ /Error/) 
 {
  $BIB[0][$NBIB_try]->{doi}=$URL;
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
  #&PRINT_it(0,1,"stdlog");
  $NBIB[0]=$NBIB_try;
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
   $BIB[0][$NBIB_try]->{volume}="none";
   $BIB[0][$NBIB_try]->{numpages}=" ";
   $BIB[0][$NBIB_try]->{journal}="";
   $BIB[0][$NBIB_try]->{doi}="DOI";
   $BIB[0][$NBIB_try]->{month}="MONTH ";
   $BIB[0][$NBIB_try]->{url}="URL";
   $BIB[0][$NBIB_try]->{issue}="ISSUE";
   $BIB[0][$NBIB_try]->{pages}="PAGES ";
   $BIB[0][$NBIB_try]->{TYPE}="article";
  }
  $BIB[0][$NBIB_try]->{KEY}="$file";
  $BIB[0][$NBIB_try]->{KEY}=~ s/.file//g;
  $BIB[0][$NBIB_try]->{KEY}=~ s/.PDF//g;
  $BIB[0][$NBIB_try]->{timestamp}="$date";
  $BIB[0][$NBIB_try]->{year}="$current_year";
  if (not $results == "no" )
  {
   $BIB[0][$NBIB_try]->{publisher}=" ";
   $BIB[0][$NBIB_try]->{journal}=" ";
  }
  $BIB[0][$NBIB_try]->{author}=" ";
  $BIB[0][$NBIB_try]->{title}=$BIB[0][$NBIB_try]->{KEY};
  $BIB[0][$NBIB_try]->{title}=~ s/_/ /g;
  $BIB[0][$NBIB_try]->{title}=~ s/-/ /g;
  #
  if ($result =~ "no") {$result="un"};
  #
  for $typ (@MANUAL_BIB_TYPS)
  {
   if (lcfirst(substr($typ,0,3)) =~ $result) {$BIB[0][$NBIB_try]->{TYPE}=$typ}
   elsif (lcfirst(substr($typ,0,2)) =~ $result) {$BIB[0][$NBIB_try]->{TYPE}=$typ}
   elsif (lcfirst(substr($typ,0,$NBIB_try)) =~ $result) {$BIB[0][$NBIB_try]->{TYPE}=$typ}
   #print "$result $BIB[0][1]->{TYPE}".lcfirst(substr($typ,0,2))."\n";
  }
  my $title=latex_encode($BIB[0][$NBIB_try]->{title});
  $BIB[0][$NBIB_try]->{title}=$title;
  $BIB[0][$NBIB_try]->{title}=~ s/'/\'/g;
  $NBIB[0]=$NBIB_try;
  open $fh, '>', "$db" ;
  print $fh Dumper $BIB[0][$NBIB_try];
  close $fh;
  &command("vim \"$db\"");
 }
 if (-f $db) {
  open my $fh, '<', "$db" ;
  my $vars;
   { local $/ = undef; $vars = <$fh>; }
   $BIB[0][$NBIB_try]= eval $vars;
  close $fh;
  &PRINT_it(0,$NBIB_try,"$in_bib_file");
 }
}
1;
