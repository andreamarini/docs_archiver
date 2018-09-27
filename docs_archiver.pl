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
# Initialize
$version="0.1";
local $| = 1;
#
# Paths
$HOME=$ENV{"HOME"};
do "$HOME/.docs_archiver/src.pl";
do "$SRC/libs/MODULES.pl";
#
print "\n Docs Archiver version $version ";
#
my $len= length($view);
if ($len eq 0) {$view="yes"};
#
# CMD line
&OPTIONS();
#
#&USER_pars_report();
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
}
#
# Repair 
#
if ($out_bib_file and $fix) {
 &FIX_it(0);
 &WRITE_the_bib(0);
}
#
# VIEW
#
if ($view){
 print "\n\n";
 &VIEW;
}
#
# JOB related operations
#
#if ($job) { 
# if ($rename or $del)   {&JOB_handle; exit };
# if ($y_file_for_input) { &JOB_get_infile; exit };
#}
#
# Running
#if ($run) { 
# &RUN_driver();
# exit;
#}
#
# Scan
#if ($scan) { 
# &SCAN_driver();
# exit;
#}
#
# Plotting
#if ($plot) { 
# &PLOT_driver();
# exit;
#}
#
# DB init
#
#&DB_init;
#
# DEFAULTs
#&DEFAULTs;
#
# Post options setups
#
#my $len= length($add);
#undef $file_to_add;
#if ($len >  0) {$file_to_add=$add};
#if ($len eq 0) {$add="1"};
#if (not $no_recursive) {$no_recursive="0"}elsif($no_recursive) {$no_recursive="1"};
#
# DB REBUILD
#if ($rebuild) {&DB_rebuild};
#
# DB UPDATE
#if (not $list) {&DB_sync};
#
# Load DB components
#&DB_load();
#
# IRUN_in
#if ($ID_in) { $IRUN_in=&have_run("ID",$ID_in) };
#
# LIST
#if ($list) { 
# &RUN_list;
# exit;
#};
#
# Open Files
#&FILES;
#
# NEW
#if ($new) { 
# if (!$material and !$ID_in) {die " A material must be provided\n"};
# &REPO_and_DB_add_object();
#};
#
# ADD
#if ($ID_in and not $del) { 
# if ($quiet) {print "\n Changes in the database:\n\n"};
# if ($add)         
#  {&REPO_add_object}
# else{
#  if ($description) {&DB_add_line($ID_in,"description")};
#  if ($material)    {&DB_add_line($ID_in,"material","$material")};
#  if ($user_tags)   {&DB_add_line($ID_in,"tag","@tags")};
#  if ($running)     {&DB_add_line($ID_in,"running","$running")};
# }
#};
#
# Remove
#if ($del and $ID_in) { &REPO_delete_object };
#
# move
#if ($ID_in and $move_to) { &DB_add_line($ID_in,"father") };
#
# Get it
#$test=&have_ID($ID_in);
#if (($get or $see) and $ID_in and &have_ID($ID_in)==1) { &REPO_get_object };
#
# Final actions
#&FILE_actions;
#
print "\n\n";
#
exit;
#
