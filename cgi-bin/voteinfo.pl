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
if (! ($ng =~ /^[a-z][a-z0-9]{1,13}(\.[a-z0-9][a-z0-9-]{0,13})+$/)) {
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

if (-f "$ng/result") {
	$path = "$ng/result";
} else {
	if (-f "$ng/posted.cfv") {
		$path = "$ng/posted.cfv";
	}
}

if ($path eq "") {
	# barf
	print "No CFV or result file for this vote!\n";
	exit(2);
}

# Output it
open(F, "<$path");
while (<F>) {
	print $_;
}
close(F);

exit(0);
