#!/usr/bin/perl 
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
#
# SYSTEM
use Cwd;
#
$HOME=$ENV{"HOME"};
my $dir = getcwd;
#
$err=system("mkdir -p $HOME/.docs_archiver");
open(SRC,">","$HOME/.docs_archiver/src.pl");
print SRC "#!/usr/bin/perl\n";
print SRC "\$SRC=\"$dir\";\n";
print SRC "\$PAPERS_db=\"/home/marini/Papers_and_Results/DATABASE/PAPERS\";\n";
print SRC "use lib \"$dir/libs\";\n";
print SRC "use lib \"$dir/ydb/libs\";\n";
close(SRC);
exit;
