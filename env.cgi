#!/usr/bin/perl -w
#	@(#) $Header$
#	vim:sw=4:ts=4:
#
#  Show all environment variables, etc

use CGI qw();

$cgi = new CGI();
print $cgi->header();

print $cgi->start_html("Environment variables!"), "\n";

print "Environment variables:<br>\n";
print "<ul>\n";
foreach (sort (keys %ENV)) {
	printf "<li>%s = %s\n", $_, $cgi->escapeHTML($ENV{$_});
}
print "</ul>\n";

print <<EOF
</html>
EOF
;

exit(0);
