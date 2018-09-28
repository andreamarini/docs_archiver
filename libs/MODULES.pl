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
