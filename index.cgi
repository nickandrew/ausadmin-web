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
	# print `printenv`
}

use CGI qw();
use CGI::Cookie qw();

use Ausadmin qw();
use Ausadmin::CookieSet qw();
use View::MainPage qw();

my $cgi = CGI->new();
my $sqldb = Ausadmin::sqldb();

my $cookies = Ausadmin::CookieSet->new($cgi, $sqldb);

# Log us in, if this CGI request included action=login
$cookies->testActionLogin();
# Log who visited where
$cookies->logIdent();

my $username = $cookies->getUserName();

$sqldb->commit();

print $cgi->header(
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

<title>aus.* newsgroups administration (hello $username)</title>
</head>
<body>
EOF

my $contents = View::MainPage::insideBody($cookies);

View::MainPage::output($contents);

print <<EOF;
</body>
</html>
EOF

exit(0);
