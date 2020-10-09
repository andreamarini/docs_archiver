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
sub OPTIONS{
&GetOptions("help"           => \$help,
            "i=s"            => \$in_bib_file,
            "doi=s"          => \$in_DOI,
            "p=s"            => \$pdf,
            "g:s"            => \$group,
            "o=s"            => \$out_bib_file,
            "a"              => \$add,
            "d"              => \$dump,
            "c"              => \$clean,
            "fix"            => \$fix,
            "view"           => \$view,
            "s"              => \$simulate,
            "r=s"            => \$replace,
            "k=s"            => \$key) or die;
sub usage {

 print <<EndOfUsage

   Syntax: docs_archiver.pl <ARGS>
           < > are optionals, [ ] are needed

   where <ARGS> must include at least one of:
                   -h                      This help
                   -i      [FILE/DIR]      INPUT bib file/directory
                   -o      [FILE]          OUTPUT bib file/directory
                   -p      [FILE/DIR]      PDF file
                   -c                      Clean the temporary files after coping
                   -a                      Add (to the default DB)
                   -d                      Dump contents
                   -fix                    Fix the INPUT bib file
                   -doi    [DOI]           Doi
                   -g      [PATTERN]       Group 
                   -r      [PATTERN]       Replace
                   -k      [PATT1,PATT2]   Keys
                   -s                      Simulate (create a temporary new bib file)
                   -v                      View

EndOfUsage
  ;
  exit;
}
}
1;
