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
#@Article{PhysRevB.62.R16235,
#  author    = {Ju\ifmmode \checks\else \vs\fika, G. and Arlauskas, K. and Vili\ifmmode \baru\else},
#  title     = {Charge transport in $\ensuremath\pi$-conjugated polymers from extraction current transients},
#  journal   = {Phys. Rev. B},
#  year      = {2000},
#  volume    = {62},
#  pages     = {R16235--R16238},
#  month     = {Dec},
#  doi       = {10.1103/PhysRevB.62.R16235},
#  file      = {:/home/marini/Papers_and_Results/DATABASE/PhysRevB.62.R16235.pdf:PDF},
#  groups    = {Polymers},
#  issue     = {24},
#  numpages  = {0},
#  publisher = {American Physical Society},
#  timestamp = {2018.09.28},
#  url       = {https://link.aps.org/doi/10.1103/PhysRevB.62.R16235},
#}
#
sub DUMP_ris{
 #
 my ($file,$pdf_file,$ID) = @_;
 #
 my $infile_data;
 my $ibib=1;
 $BIB[$ID][1]->{TYPE}="Article";
 $infile_data = &read_file($file);
 my @infile=split(/\n/,$infile_data);
 my $size = scalar @infile;
 for ($ivar = 0; $ivar < $size; $ivar = $ivar + 1)
  {
   chomp($infile[$ivar]);
   $infile[$ivar] =~ s/\r//g;
   $infile[$ivar] =~ s/",/},/g;
   my $FIELD=(split(" - ",$infile[$ivar]))[0];
   my $VAL=(split(" - ",$infile[$ivar]))[1];
   if ($FIELD =~ /AU/)
   { 
    $AUTHOR=(split(",",$VAL))[1]." ".(split(",",$VAL))[0];
    if (    $BIB[$ID][1]->{author}){$BIB[$ID][1]->{author}.=", ".$AUTHOR}; 
    if (not $BIB[$ID][1]->{author}){$BIB[$ID][1]->{author} =$AUTHOR};
   }
   if ($FIELD =~ /TI/) {$BIB[$ID][1]->{title} =$VAL};
   if ($FIELD =~ /JA/) {$BIB[$ID][1]->{journal} =$VAL};
   if ($FIELD =~ /PY/) {$BIB[$ID][1]->{year} =(split("\/",$VAL))[0]};
   if ($FIELD =~ /PB/) {$BIB[$ID][1]->{publisher} =$VAL};
   if ($FIELD =~ /UR/) {$BIB[$ID][1]->{url} =$VAL};
   if ($FIELD =~ /L3/ and not $BIB[$ID][1]->{KEY}) {$BIB[$ID][1]->{KEY} =$VAL};
  }
 $NBIB[$ID]=1; 
 if ($pdf_file) {$BIB[$ID][1]->{PDF}="$pdf_file"};
 #
 &command("$SRC/tools/doi2bib \"$BIB[$ID][1]->{url}\" > tmp.bib");
 &DUMP_bib("tmp.bib",$pdf_file,0,1);
 &command("rm -f tmp.bib");
 #&PRINT_it(0,1,"stdlog");
}
1;
