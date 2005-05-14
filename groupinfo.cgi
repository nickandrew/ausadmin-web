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
use CGI::Cookie qw();

use Ausadmin qw();
use Ausadmin::CookieSet qw();
use View::MainPage qw();
use View::GroupPage qw();

my $cgi = new CGI();
my $sqldb = Ausadmin::sqldb();

my $cookies = Ausadmin::CookieSet->new($cgi, $sqldb);


# Log us in, if this CGI request included action=login
$cookies->testActionLogin();
# Log who visited where
$cookies->logIdent();

# Figure out which newsgroup we're talking about here
my $request_uri = $ENV{REQUEST_URI};
# Look for "/newsgroup_name/something"
$request_uri =~ s/.*groupinfo.cgi//;

my @frag = split(/\//, $request_uri);
my $ng = $frag[1];

my $username = $cookies->getUserName();

$sqldb->commit();

print $cgi->header(
	-type => 'text/html',
	-status => '200 OK',
	-expires => '+0m',
	-cookie => $cookies->getList(),
);

my $uri_prefix = Ausadmin::config('uri_prefix');

print <<EOF;
<!DOCTYPE html PUBLIC "-//W3C/DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
<link type="text/css" rel="stylesheet" href="$uri_prefix/style.css" />

<title>Newsgroup $ng</title>
</head>
<body>
EOF

my $contents = View::GroupPage::insideBody($cookies, $ng);
View::MainPage::output($contents);

print <<EOF;
</body>
</html>
EOF

exit(0);
