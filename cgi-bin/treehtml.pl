#!/usr/bin/perl
#	treegif.pl - Output a gif containing a linked newsgroups tree


chdir "../data";
if (! -f "ausgroups") {
	print "Content-type: text/plain\n";
	print "Status: 404 Missing aus.* newsgroup file\n\n";
	exit(2);
}

@in = stat("ausgroups");
@out = stat("ausgroups.html");

if (! -f "ausgroups.html" || $in[9] > $out[9]) {
	system "../bin/grouptree.pl";
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
