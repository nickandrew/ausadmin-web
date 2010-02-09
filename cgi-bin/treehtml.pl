#!/usr/bin/perl
#	@(#) treehtml.pl - Output html containing a linked newsgroups tree
#

my $AUSADMIN_HOME = "/home/ausadmin";

chdir "$AUSADMIN_HOME/data";

if (! -f "ausgroups") {
	print "Content-type: text/plain\n";
	print "Status: 404 Missing aus.* newsgroup file\n\n";
	exit(2);
}

@in = stat("ausgroups");
@out = stat("ausgroups.html");

if (! -f "ausgroups.html" || $in[9] > $out[9]) {
	system "$AUSADMIN_HOME/bin/grouptree.pl";
	if ($? > 0) {
		print "Content-type: text/plain\n";
		print "Status: 500 Generator broken\n\n";
		exit(2);
	}
}

print "Content-type: text/html\n";
print "\n";

open(F, "<ausgroups.html") || die "Unable to open ausgroups.html: $!";
while (<F>) {
	print $_;
}

close(F);
exit(0);
