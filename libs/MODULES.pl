#!/usr/bin/perl
#
#        Copyright (C) 2000-2018 the YAMBO team
#              http://www.yambo-code.org
#
# Authors (see AUTHORS file for details): AM
#
# Based on the original driver written by CH
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
#
# SYSTEM
use Getopt::Long;
use Encode;
use File::Find;
use File::Copy;
use File::Basename;
use Data::Dumper;
use List::Util 'max';
use List::Util 'min';
use Time::HiRes qw(gettimeofday tv_interval);   # Not widely supported
use Cwd 'abs_path';
#
# LIBs 
#use DEFAULTs;
use UTILS_docs;
use UTILS;
use OPTIONS;
#
# I/O 
use PRINT_it;
use DUMP_it;
use DUMPER_io;
use WRITE_the_bib;
#
# Operations
use FIX_it;
use ADD_it;
#
# Functions
use prompt;
#
#use DB_rebuild;
#use DB_init;
#use DB_load;
#use DB_sync;
#
#use DB_add_line;
#use DB_del_line;
#
#use FILES;
#use FILE_actions;
#
#use REPO_delete_object;
#use REPO_add_object;
#use REPO_get_object;
#use REPO_and_DB_add_object;
#
#use RUN_print;
#use RUN_list;
#
#use JOB_utils;
#
# SCAN
#use SCAN_driver;
#use SCAN_select_files;
#use SCAN_the_file;
#
# RUN
#use RUN_driver;
#
# PLOT
#use PLOT_driver;
#use PLOT_load_data_from_user_file;
#use PLOT_graph;
#use PLOT_utils;
#
#use functions;
#
