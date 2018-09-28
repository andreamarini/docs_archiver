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
sub EMPTY{
 $in_bib_file=$pdf;
 $in_bib_file=~ s/.pdf/.bib/g;
 $BIB[0][1]->{TYPE}="article";
 $BIB[0][1]->{KEY}="$pdf";
 $BIB[0][1]->{KEY}=~ s/.pdf//g;
 $BIB[0][1]->{timestamp}="$date";
 $BIB[0][1]->{volume}="none";
 $BIB[0][1]->{year}=" ";
 $BIB[0][1]->{numpages}=" ";
 $BIB[0][1]->{doi}=" ";
 $BIB[0][1]->{publisher}=" ";
 $BIB[0][1]->{author}=" ";
 $BIB[0][1]->{month}=" ";
 $BIB[0][1]->{url}=" ";
 $BIB[0][1]->{issue}=" ";
 $BIB[0][1]->{journal}=" ";
 $BIB[0][1]->{title}=" ";
 $BIB[0][1]->{pages}=" ";
 $NBIB[0]=1;
 open $fh, '>', "$in_bib_file".".db" ;
 print $fh Dumper $BIB[0][1];
 close $fh;
 $result=&prompt_yn("Possible TYPES are @BIB_TYPS. Continue?");
 if ($result eq "y") {
  &command("vim $in_bib_file".".db");
  open my $fh, '<', "$in_bib_file".".db" ;
  my $vars;
   { local $/ = undef; $vars = <$fh>; }
   $BIB[0][1]= eval $vars;
  close $fh;
  &PRINT_it(0,1,"$in_bib_file");
 }
 &command("rm -f $in_bib_file".".db");
}
1;
