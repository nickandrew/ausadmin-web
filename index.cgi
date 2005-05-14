#!/usr/bin/perl -w
#	@(#) $Header$
#	vim:sw=4:ts=4:
#
#  This is the main CGI for the ausadmin website

use strict;
use CGI::Carp qw(fatalsToBrowser);

BEGIN {
	if (-x './config.pl') {
		require "./config.pl";
	}
	# print "Content-Type: text/plain\n\n";
}

use CGI qw();
use CGI::Cookie qw();

use Ausadmin::CookieSet qw();
use View::MainPage qw();

my $cgi = new CGI();

my $cookies = Ausadmin::CookieSet->new($cgi);
my $fred = $cookies->idCookie();

print CGI::header(
	-type => 'text/html',
	-status => '200 OK',
	-expires => '+0m',
	-cookie => $cookies->getList(),
);

print <<EOF;
<!DOCTYPE html PUBLIC "-//W3C/DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
<link type="text/css" rel="stylesheet" href="style.css" />

<title>aus.* newsgroups administration (hello $fred)</title>
</head>
<body>
EOF

View::MainPage::output(View::MainPage::insideBody());

print <<EOF;
</body>
</html>
EOF

exit(0);
