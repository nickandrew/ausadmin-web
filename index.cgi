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
	# print `printenv`;
}

use CGI qw();
use CGI::Carp qw(fatalsToBrowser);
use CGI::Cookie qw();

use Ausadmin qw();
use Ausadmin::CookieSet qw();
use Include qw();
use Data::Dumper qw();
use View::MainPage qw();

$Data::Dumper::Indent = 1;

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

my ($frame, $arg) = getFrameArg();

my $uri_prefix = Ausadmin::config('uri_prefix');

my $vars = {
	HIERARCHY_PREFIX => 'aus',
	URI_PREFIX => $uri_prefix,
	USERNAME => $username,
};

my $container = View::MainPage->new(
	cookies => $cookies,
	content => "$frame.dir/$arg",
	vars => $vars,
	sqldb => $sqldb,
);

$container->getCGIParameters($cgi);

my $include = new Include(vars => $vars, view => $container);

$container->setInclude($include);
my $string = $include->resolveFile("$frame.frame");

$sqldb->commit();

print $string;

exit(0);

# ---------------------------------------------------------------------------
# Get HTML frame and argument
# ---------------------------------------------------------------------------

sub getFrameArg {

	my $filename = $ENV{PATH_INFO} || '';
	$filename =~ s/^\///; # cut leading slash
	$filename =~ s/\.\.+//; # cut out two or more dots in a row

	my ($frame, $arg);
	if ($filename =~ /^([^\/]+)\/(.+)/) {
		($frame, $arg) = ($1, $2);
	} else {
		($frame, $arg) = ('Ausadmin', 'Default');
	}

	return ($frame, $arg);
}
