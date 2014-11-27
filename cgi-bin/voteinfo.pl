#!/usr/bin/perl
#	@(#) voteinfo - Get vote information: CFV or result (depending on
#	vote status).
#

use CGI qw/:standard/;

my $AUSADMIN_HOME = "/home/ausadmin";

my $query = new CGI();

if (!-d "$AUSADMIN_HOME/vote") {

	# barf - KLUDGE
	print "Content-Type: text/plain\n";
	print "\n";
	print "This script cannot run because its environment is not setup.\n";
	print "Please tell ausadmin\@aus.news-admin.org\n";
	exit(2);
}

chdir("$AUSADMIN_HOME/vote");

print "Content-Type: text/plain\n";
print "\n";

my $ng = $query->param('vote') || $query->param('newsgroup');
my $doc = $query->param('doc');

# Check supplied newsgroup for validity
if (!($ng =~ /^[a-z][a-z0-9]{1,13}(\.[a-z0-9][a-z0-9-]{0,13})+(:\d\d\d\d-\d\d-\d\d)?$/)) {

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
if (!-d "$ng") {
	print "There is no vote known for the newsgroup $ng\n";
	exit(2);
}

# Now, do we have a result file or a Call-For-Votes?
# The default is whichever file we find first
my $path;

if (!$doc) {
	my @files = qw/result cancel-article.txt cfv.signed cfv rfd/;

	foreach (@files) {
		if (-f "$ng/$_") {
			$path = "$ng/$_";
			last;
		}
	}
}


if ($doc eq 'result' && -f "$ng/result") {
	output("$ng/result");
	exit(0);
}

if ($doc eq 'result' && -f "$ng/cancel-article.txt") {
	output("$ng/cancel-article.txt");
	exit(0);
}

if ($doc eq 'rfd' && -f "$ng/rfd") {
	output("$ng/rfd");
	exit(0);
}

if ($doc eq 'cfv' && -f "$ng/cfv.signed") {

	# Output the signed call for votes
	output("$ng/cfv.signed");
	exit(0);
}

if ($doc eq 'cfv' && -f "$ng/cfv") {

	# Output the unsigned call for votes if there is no signed one
	output("$ng/cfv");
	exit(0);
}

if (!$path) {
	print "Unable to find whatever it is you want to see!\n";
	exit(2);
}

output($path);

exit(0);

# Output contents of a file to stdout

sub output {
	my $path = shift;
	open(F, "<$path");
	while (<F>) {
		print $_;
	}
	close(F);
}
