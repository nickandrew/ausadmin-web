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
	print "Content-Type: text/plain\n\n";
	# print "Perllib is $ENV{PERLLIB}<br>\n";
	# print "pwd is " . `pwd` . "<br>\n";
}

use CGI qw();
use CGI::Cookie qw();

use Ausadmin::CookieSet qw();

my $cgi = new CGI();

my $cookies = Ausadmin::CookieSet->new($cgi);
my $fred = $cookies->idCookie();

my $newcookie = CGI::Cookie->new(
	-name => 'Stuff',
	-value => 'Bother',
	-expires => '+1h',
);

$cookies->addCookie($newcookie);

print CGI::header(
	-content_type => 'text/html3',
	-cookie => $cookies->getList(),
);

print <<EOF;
<html>
<head>
<title>Cookies</title>
</head>
<body>
<pre>
EOF

print Dumper($newcookie, $fred);

print <<EOF;
</pre>
</body>
</html>
EOF

exit(0);
