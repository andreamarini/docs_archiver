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
sub DUMP_it{
 #
 my ($file,$ID) = @_;
 #
 my @NOBIBS = qw(comment StaticGroup Comment);
 my @BIB_TYPS = qw(Article Book Conference Misc Unpublished PhdThesis InCollection Other Manual abstract title InBook article);
 #
 if (not -f $file) {return};
 if ($dump) { open $fh, '>', "$file".".db" or die "Can't write '$file' db: $!"};
 #
 my $infile_data;
 my $ig=-1;
 my $ic=-1;
 my $ibib=0;
 my $new_entry=0;
 $infile_data = &read_file($file);
 my @infile=split(/\n/,$infile_data);
 my $size = scalar @infile;
 for ($ivar = 0; $ivar < $size; $ivar = $ivar + 1){
  #
  chomp($infile[$ivar]);
  $infile[$ivar] =~ s/\r//g;
  #
  if (substr("$infile[$ivar]",0,8) eq "\@Comment") {
   if ($infile[$ivar] =~ /grouping/)
   {
    for ($ivp = $ivar+2; $ivp < $size; $ivp = $ivp + 1)
    {
     if ($infile[$ivp] =~ /StaticGroup/) 
     { 
      $ig=$ig+1;
      $NGRP[$ID]=$ig;
      $str=$infile[$ivp];
      $str =~ s/\\//g;
      $GRP[$ID][$ig]->{LEVEL} = substr("$str",0,1);
      my $n=14;
      $str =~ s/^.{$n}//s;
      $GRP[$ID][$ig]->{NAME}=(split(";",$str))[0];
      if ($GRP[$ID][$ig]->{LEVEL}==1) {$MASTER=$GRP[$ID][$ig]->{NAME}};
      $GRP[$ID][$ig]->{MASTER}=$MASTER;
      #print "\n $ig L=$GRP[$ID][$ig]->{LEVEL} N=$GRP[$ID][$ig]->{NAME} M=$GRP[$ID][$ig]->{MASTER}\n";
     }
    }
   }else{
    $ic=$ic+1;
    $COMMENT[$ID][$ic]=$infile[$ivar];
    $NCOMMENT[$ID]=$ic;
   }
  }
  if (substr("$infile[$ivar]",0,1) =~ "@") {
   $infile[$ivar] =~ s/@/ /g; 
   $infile[$ivar] =~ s/{/ /g; 
   $TYP=(split(" ",$infile[$ivar]))[0];
   chomp($TYP);
   my @matches = grep { /$TYP/ } @BIB_TYPS;
   if (!@matches){
    #print "TYPR $TYP unlisted \n";
    next};
   $ibib=$ibib+1;
   $new_entry=1;
   $BIB[$ID][$ibib]->{TYPE}=$TYP;
   $BIB[$ID][$ibib]->{KEY}=(split('\s+',$infile[$ivar]))[2];
   $BIB[$ID][$ibib]->{KEY} =~ s/,//g; 
  }
  #
  if (substr("$infile[$ivar]",0,1) =~ "}") 
  {
   if ($dump) {print $fh Dumper $BIB[$ID][$ibib]};
   undef $new_entry;
  };
  #
  if ($new_entry)
  {
   if ("$infile[$ivar]" =~ "="){
    $FIELD=(split('\=',$infile[$ivar]))[0];
    $FIELD=ucfirst "$FIELD";
    $FIELD =~ s/^\s+|\s+$//g;
    $VAL=(split('\=',$infile[$ivar]))[1];
    $VAL =~ s/{//g;
    $VAL =~ s/},//g;
    $VAL =~ s/}//g;
    if (not substr("$infile[$ivar]",-2,2) =~ "}," and not substr("$infile[$ivar]",-1,1) =~ "}") 
    { 
     for ($ivp = $ivar+1; $ivp < $size; $ivp = $ivp + 1){
      my $V_more=$infile[$ivp];
      $V_more =~ s/{//g;
      $V_more =~ s/},//g;
      $V_more =~ s/}//g;
      $V_more =~ s/^\s+|\s+$//g;
      $VAL = $VAL." ".$V_more;
      if (substr("$infile[$ivp]",-2,2) =~ "}," or substr("$infile[$ivp]",-1,1) =~ "}") {last}; 
     }
     $ivar=$ivp;
    }
    $VAL =~ s/^\s+|\s+$//g;
    $BIB[$ID][$ibib]->{$FIELD}=$VAL;
   };
  }
  #
 }
 $NBIB[$ID]=$ibib;
 if ($dump) {close $fh or die "Can't close '$file': $!"};
}
1;
