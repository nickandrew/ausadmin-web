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
use View::GroupPage qw();

my $cgi = new CGI();
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

my $filename = $ENV{PATH_INFO} || 'aus.no.newsgroup';
$filename =~ s/^\///; # cut leading slash
$filename =~ s/\.\.+//; # cut out two or more dots in a row

my $ng = $filename;

my $object = View::GroupPage->new(cookies => $cookies, content => $filename, newsgroup => $ng);
my $vars = {
	HIERARCHY_PREFIX => 'aus',
	USERNAME => $username,
	NEWSGROUP => $ng,
};

my $include = new Include(vars => $vars, view => $object);

my $string = $include->resolveFile($frame_file);

print $string;

exit(0);
