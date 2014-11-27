#!/usr/bin/perl

push(@INC, "/home/ausadmin/perllib");
$ENV{AUSADMIN_WEB}  = "/var/www/aus.news-admin.org";
$ENV{AUSADMIN_HOME} = "/home/ausadmin";
$ENV{AUSADMIN_DATA} = "/home/ausadmin/data";
$ENV{AUSADMIN_HIER} = "aus";

if ($ENV{HTTP_HOST} =~ /^([^.]+)\./) {
	my $hier = $1;

	$ENV{AUSADMIN_HIER} = $hier;
	$ENV{AUSADMIN_DATA} = "/home/ausadmin/data/$hier.data";

	if (!-d $ENV{AUSADMIN_DATA}) {
		print qq{Content-Type: text/plain\n\nThere is no data on the news-admin.org website for $hier.*, sorry\n};
		exit(8);
	}
}

if (!-d $ENV{AUSADMIN_HOME}) {
	die "No such directory: $ENV{AUSADMIN_HOME}";
}

1;
