#!/usr/bin/perl
#	@(#) $Header$

use strict;
use CGI::Carp qw(fatalsToBrowser);

BEGIN {
	if (-x './config.pl') {
		require "./config.pl";
	}
}

use CGI qw();
use View::MainPage qw();
use View::GroupPage qw();

my $cgi = new CGI();

# Figure out which newsgroup we're talking about here
my $request_uri = $ENV{REQUEST_URI};
# Look for "/newsgroup_name/something"
$request_uri =~ s/.*groupinfo.cgi//;

my @frag = split(/\//, $request_uri);
my $ng = $frag[1];

print CGI::header();

print <<EOF;
<!DOCTYPE html PUBLIC "-//W3C/DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
<link type="text/css" rel="stylesheet" href="style.css" />

<title>Newsgroup $ng</title>
</head>
<body>
EOF

View::MainPage::output(View::GroupPage::insideBody($ng));

print <<EOF;
</body>
</html>
EOF

exit(0);
