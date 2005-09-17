#!/usr/bin/perl -w
#	@(#) $Header$
#	vim:sw=4:ts=4:
#
#	Ausadmin proposal data entry, editing, etc
#

use strict;

use CGI qw();
use CGI::Carp qw(fatalsToBrowser);
use Date::Format qw(time2str);

use Ausadmin qw();
use Ausadmin::CookieSet qw();
use View::Deprecated qw();
use View::NewProposal qw();

my $cgi = new CGI();
my $sqldb = Ausadmin::sqldb();

my $cookies = Ausadmin::CookieSet->new($cgi, $sqldb);

# Log who visited where
$cookies->logIdent();

my $id = $cookies->getIDToken();
my $username = $cookies->getUserName();

$sqldb->commit();

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

<title>ausadmin proposals (hello $id, $username)</title>
</head>
<body>
EOF

my $newprop = View::NewProposal->new($cookies);

my $contents = $newprop->asHTML();

View::Deprecated::output($contents);

print <<EOF;
</body>
</html>
EOF

exit(0);
