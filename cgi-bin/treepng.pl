#!/usr/bin/perl
#	treepng.pl - Output a png containing a linked newsgroups tree
#

my $AUSADMIN_HOME = "/home/ausadmin";

chdir "$AUSADMIN_HOME/data";
if (! -f "ausgroups") {
	print "Content-type: text/plain\n";
	print "Status: 404 Missing aus.* newsgroup file\n\n";
	exit(2);
}

@in = stat("ausgroups");
@out = stat("grouptree.png");

if (! -f "grouptree.png" || $in[9] > $out[9]) {
	system "$AUSADMIN_HOME/bin/grouptree.pl";
	if ($? > 0) {
		print "Content-type: text/plain\n";
		print "Status: 500 Generator broken\n\n";
		exit(2);
	}
}

print "Content-type: image/png\n";
print "\n";

open(F, "<grouptree.png") || die "Unable to open grouptree.png $!";
while (<F>) {
	print $_;
}
close(F);
exit(0);
