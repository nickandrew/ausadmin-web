#!/usr/bin/perl

use strict;
use CGI::Carp qw(fatalsToBrowser);

BEGIN {
	if (-x './config.pl') {
		require "./config.pl";
	}
}

use CGI qw();
use View::MainPage qw();

print CGI::header();
print CGI::start_html(
	-title => 'aus.* newsgroups administration',
	-BGCOLOR => 'white'
	);

View::MainPage::output(View::MainPage::insideBody());

print CGI::end_html();

exit(0);
