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
use CGI::Cookie qw();

use Ausadmin qw();
use Ausadmin::CookieSet qw();
use Include qw();
use Data::Dumper qw();
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

my $frame_file = 'Default.frame';

my $filename = $ENV{PATH_INFO} || 'Default';
$filename =~ s/^\///; # cut leading slash
$filename =~ s/\.\.+//; # cut out two or more dots in a row

my $object = View::MainPage->new(cookies => $cookies, content => $filename);
my $vars = {
	HIERARCHY_PREFIX => 'aus',
};
my $include = new Include(vars => $vars, view => $object);

my $string = $include->resolveFile($frame_file);

print $string;

exit(0);
