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
use Vote qw();
use View::MainPage qw();
use View::Proposal qw();

my $cgi = new CGI();
my $proposal = $cgi->param('proposal');

$proposal =~ s/[^a-z0-9.:-]/_/g;

print CGI::header();

if (! $proposal) {
	print qq{<html><head><title>Error!</title></head><body>No proposal!</body></html};
	exit(0);
}

my $vote = new Vote(
	vote_dir => "$ENV{AUSADMIN_HOME}/vote",
	name => $proposal
);

die "No vote" if (!defined $vote);

print <<EOF;
<!DOCTYPE html PUBLIC "-//W3C/DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
<link type="text/css" rel="stylesheet" href="style.css" />

<title>Proposal $proposal</title>
</head>
<body>
EOF

View::MainPage::output(View::Proposal::insideBody($vote));

print <<EOF;
</body>
</html>
EOF

exit(0);
