#!/usr/bin/perl
#	Emit a series of links to newsgroups work in progress
#
# $Source$
# $Revision$
# $Date$

my $AUSADMIN_HOME = "/home/ausadmin";

chdir "$AUSADMIN_HOME/Wip";

my $count = 0;
my %activity;

foreach my $fn (<*>) {
	open(F, "<$fn") || next;
	my %data;

	while (<F>) {
		chomp;
		last if (/^$/);
		my($key, $value) = ($_ =~ /([^:]*):\s+(.*)/);
#		print "key: $key, value: /$value/\n";
		$data{$key} = $value;
	}

	close(F);

	my $key = $fn;
	if ($data{Updated} ne "") {
		$key = "$data{Updated} $fn";
	}
#	print "Key is $key\n";

	$activity{$key} = { };

	if ($data{Name} ne "") {
		$activity{$key}->{text} = $data{Name};
	} else {
		$activity{$key}->{text} = $fn;
	}

	$activity{$key}->{fn} = $fn;
	$activity{$key}->{updated} = $data{Updated};
	$activity{$key}->{link} = $data{Link};
	$activity{$key}->{status} = $data{Status};
}

my $first = 1;

# Emit gathered info
foreach my $key (sort {$b cmp $a} (keys %activity)) {
	my $r = $activity{$key};

	if ($first) {
		print "<ol>\n";
		$first = 0;
	}

	print "<li>";
	if ($r->{link} ne "n") {
		printf "<a href=\"%s\">", ($r->{link} eq "" ? "/Wip/$r->{fn}" : $r->{link});
	}
	print $r->{text};
	if ($r->{link} ne "n") {
		printf "</a>";
	}
	if ($r->{status} ne "") {
		print " Status: $r->{status}";
	}
	if ($r->{link} ne "n" && $r->{updated} ne "") {
		print " (updated $r->{updated})";
	}
	print "\n";
	$count++;
}

if ($first) {
	print "None at present\n";
} else {
	print "</ol>\n";
}

exit(0);
