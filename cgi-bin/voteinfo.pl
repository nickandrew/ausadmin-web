#!/usr/bin/perl
#	@(#) voteinfo - Get vote information: CFV or result (depending on
#	vote status).

use CGI qw/:standard/;

$query = new CGI;
if (! -d "../vote") {
	# barf - KLUDGE
	exit(2);
}

print "Content-Type: text/plain\n";
print "\n";

chdir("../vote");

$ng = $query->param('newsgroup');

# Check supplied newsgroup for validity
if (! ($ng =~ /^[a-z][a-z0-9]{1,13}(\.[a-z0-9][a-z0-9-]{0,13})+(:\d\d\d\d-\d\d-\d\d)?$/)) {
	# barf
	print "Newsgroup <$ng> does not verify\n";
	exit(2);
}

if ($ng =~ /(-\.)|(-$)/) {
	# barf
	print "Newsgroup <$ng> has trailing dash\n";
	exit(2);
}

# Otherwise, check if there is a vote
if (! -d "$ng") {
	print "There is no vote known for the newsgroup $ng\n";
	exit(2);
}

# Now, do we have a result file or a Call-For-Votes?
# Use whichever file we find first

my @files = qw/result cancel-article.txt posted.cfv rfd/;
my $path;

foreach (@files) {
	if (-f "$ng/$_") {
		$path = "$ng/$_";
		last;
	}
}

if (!$path) {
	print "No RFD or CFV or result file for this vote!\n";
	exit(2);
}

# Output it
open(F, "<$path");
while (<F>) {
	print $_;
}
close(F);

exit(0);
