#!/usr/bin/perl
#	treegif.pl - Output a gif containing a linked newsgroups tree
#
#	$Revision$
#	$Source$
#	$Date$

my $AUSADMIN_HOME = "/home/ausadmin";

chdir "$AUSADMIN_HOME/data";
if (! -f "ausgroups") {
	print "Content-type: text/plain\n";
	print "Status: 404 Missing aus.* newsgroup file\n\n";
	exit(2);
}

@in = stat("ausgroups");
@out = stat("grouptree.gif");

if (! -f "grouptree.gif" || $in[9] > $out[9]) {
	system "$AUSADMIN_HOME/bin/grouptree.pl";
	if ($? > 0) {
		print "Content-type: text/plain\n";
		print "Status: 500 Generator broken\n\n";
		exit(2);
	}
}

print "Content-type: image/gif\n";
print "\n";

open(F, "<grouptree.gif") || die "Unable to open grouptree.gif: $!";
while (<F>) {
	print $_;
}
close(F);
exit(0);
