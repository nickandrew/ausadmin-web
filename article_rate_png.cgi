#!/usr/bin/perl
#	@(#) $Header$

BEGIN {
	if (-x './config.pl') {
		require "./config.pl";
	}
}

use CGI qw();

my $cgi = new CGI();

my $newsgroup = $cgi->param('newsgroup');
$newsgroup =~ s,/,,g;
$newsgroup =~ s/\.\.*/./g;

my $path = "$ENV{AUSADMIN_HOME}/Mrtg/$newsgroup-month.png";

if (!open(F, "<$path")) {
	print <<EOF;
Content-type: text/plain

Sorry, an image for $ng does not exist.
EOF
	exit(0);
}

my @stat = stat($path);

my $size = $stat[7];

print <<EOF;
Content-type: image/png
Content-Length: $size

EOF

print <F>;
close(F);

exit(0);
