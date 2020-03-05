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
sub ADD_it{
 #
 my $result;
 my @founds;
 my @matches;
 my $to_add=0;
 print "\n BIB entries to be added\n\n";
 if ($key) 
 {
  @founds=&FIND_bib_element_using_KEY(0,$key);
 }
 #
 for (my $i1 = 1; $i1 <= $NBIB[0]; $i1 = $i1 + 1){
  if ($BIB[0][$i1]->{doi}) {my $if1=&FIND_bib_element_using_VAL(1,"doi","$BIB[0][$i1]->{doi}")};
  my $if2=&FIND_bib_element_using_VAL(1,"title","$BIB[0][$i1]->{title}");
  if (    $key) {@matches = grep { /\b$i1\b/ } @founds};
  if (not $key) {@matches = qw(1)};
  if (not $if1 and not $if2 and @matches){
   if ($group) {$BIB[0][$i1]->{groups}=$group};
   if ($BIB[0][$i1]->{PDF})  {$BIB[0][$i1]->{file}=":$PAPERS_db/$BIB[0][$i1]->{PDF}:PDF"};
   #
   # Author's fix
   #
   if ($BIB[0][$i1]->{Author}) 
   {
    my $authors=latex_encode($BIB[0][$i1]->{Author});
    $BIB[0][$i1]->{Author}=$authors;
   }
   if ($BIB[0][$i1]->{title}) 
   {
    my $authors=latex_encode($BIB[0][$i1]->{title});
    $BIB[0][$i1]->{title}=$authors;
   }
   &PRINT_it(0,$i1,"stdlog");
   $result=&prompt_yn("Add this entry?");
   if ($result eq "y" and not $simulate) 
   {
    if ($pdf) {
     if (-f $pdf) {&command("cp \"$BIB[0][$i1]->{PDF}\" $PAPERS_db")};
     if (-d $pdf) {&command("cp \"$pdf/$BIB[0][$i1]->{PDF}\" $PAPERS_db")};
    }
    $to_add=1;
    $NBIB[1]=$NBIB[1]+1;
    %{$BIB[1][$NBIB[1]]}= %{$BIB[0][$i1]};
    if ($clean) {
     &command("rm -f \"$BIB[0][$i1]->{PDF}\"");
     &command("rm -f \"$in_bib_file\"");
     &command("rm -f \"$BIB[0][$i1]->{PDF}\""."db");
    };
   }else{undef $clean};
  }elsif ($if1) {print "!!! ENTRY ALREADY IN THE DB !!!\n\n\n";&PRINT_it(1,$if1-1,"stdlog")
  }elsif ($if2) {print "!!! ENTRY ALREADY IN THE DB !!!\n\n\n";&PRINT_it(1,$if2-1,"stdlog")};
 }
 #
 if ($to_add and not $simulate) {
  &WRITE_the_bib($out_bib_file,1,1);
 };
 #
}
1;
