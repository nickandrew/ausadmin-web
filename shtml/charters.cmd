#!/usr/bin/perl
#	Emit a series of links to newsgroups charters

# $Revision$
# $Date$

chdir "Charters";
# for $i (<*>) {
# 	print "<li><a href=\"Charters/$i\">$i</a>\n";
# }

$count = 0;
foreach my $fn (<*>) {
	next if ($fn !~ /^[a-z0-9.-]+$/);

	open(F, "<$fn") || next;
	$count++;
	my %data;

	while (<F>) {
		chop;
		last if (/^$/);
		my($key, $value) = ($_ =~ /([^:]*):\s+(.*)/);
		last if ($key eq "");
#		print "key: $key, value: /$value/\n";
		$data{$key} = $value;
	}

	close(F);
#	my $key = $fn;

	if ($data{Link} eq "") {
		print "<li><a href=\"Charters/$fn\">$fn</a>\n";
		next;
	}

	my $name = $fn;
	if ($data{Name} ne "") {
		$name = $data{Name};
	}

	print "<li><a href=\"$data{Link}\">$name</a>\n";
}

if ($count == 0) {
	print "<li>None at present\n";
}

exit(0);
