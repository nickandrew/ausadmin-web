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

use Ausadmin::CookieSet qw();
use Vote qw();
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

my $proposal = $cgi->param('proposal');

$proposal =~ s/[^a-z0-9.:-]/_/g;

if (! $proposal) {
	print qq{<html><head><title>Error!</title></head><body>No proposal!</body></html};
	exit(0);
}

my $vote = new Vote(
	vote_dir => "$ENV{AUSADMIN_HOME}/vote",
	name => $proposal
);

die "No vote" if (!defined $vote);

my $frame_file = 'Proposal.frame';

my $object = View::MainPage->new(cookies => $cookies, vote => $vote);
my $vars = {
	HIERARCHY_PREFIX => 'aus',
	USERNAME => $username,
	TITLE => "Proposal $proposal",
};

my $include = new Include(vars => $vars, view => $object);

my $string = $include->resolveFile($frame_file);

print $string;

exit(0);
