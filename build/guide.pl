# Copyright (c) 2013 Peter Stuifzand
# Copyright (c) 2013 All contributors mentioned in the AUTHORS file
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

use strict;
use warnings;

use File::Slurp 'read_file', 'write_file';
use File::Spec::Functions 'catfile';
use File::Copy;
use Data::Dumper;
use Text::Markdown 'markdown';

sub do_include {
    my ($filename) = @_;
    print "Including $filename\n";
    my @lines = read_file($filename);
    if ($filename !~ m/\.inc/) {
        for (@lines) {
            s/^/    /;
        }
        push @lines, "\n";
        push @lines, "<p class='example-filename'><a href='$filename'>$filename</a></p>";
    }
    return join '', @lines;
}

sub process_txt_file {
    my ($infile, $outfile) = @_;

    my $md = read_file($infile);
    my ($title) = ($md =~ m/^(.+?)$/ms);

    $md =~ s/^!include\s"([^"]+)"$/do_include($1)/gems;

    my $html = markdown($md);

    $html =~ s{<pre>}{<pre class="prettyprint linenums">}g;

    my $pre = <<"HEADER";
<!DOCTYPE html>
<html><head>
<title>$title</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="//netdna.bootstrapcdn.com/twitter-bootstrap/2.2.2/css/bootstrap-combined.min.css" rel="stylesheet">
<link href="style.css" rel="stylesheet">
</head>
<body>
<div class="container"><div class="span12">
HEADER

    my $post = <<"FOOTER";
<script src="//netdna.bootstrapcdn.com/twitter-bootstrap/2.2.2/js/bootstrap.min.js"></script>
</div></div>
</body></html>
FOOTER

    write_file($outfile, $pre . $html . $post);

    return;
}

my $guide_dir = 'guide';

opendir my $dirh, $guide_dir or die "Can't open '$guide_dir'";
my @files;
while (defined(my $file = readdir($dirh))) {
    next if $file =~ m/^\.+$/;
    next if $file !~ m/\.(txt|css)$/;
    push @files, $file;
}
close $dirh;

@files = sort @files;

for my $infile (@files) {
    my $outfile = $infile;

    if ($infile =~ m/\.txt$/) {
        $outfile =~ s/\.txt/.html/;
    }

    $infile  = catfile('guide', $infile);
    $outfile = catfile('out', $outfile);
    print $infile . " => " . $outfile . "\n";

    if ($infile =~ m/\.txt$/) {
        process_txt_file($infile, $outfile);
    }
    else {
        copy($infile, $outfile);
    }
}

