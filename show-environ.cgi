#!/usr/bin/perl -w
#	@(#) $Header$
#	vim:sw=4:ts=4:
#
#  Show our environment, any cookies received, etc.

use CGI qw();

my $cgi = new CGI qw();

print "Content-Type: text/html\n";
print "Expires: 0\n\n";

print <<EOF;
<html>
 <head>
  <title>CGI environment</title>
 </head>
 <body>
EOF

print "<h1>Environment Variables</h1>\n";

print qq{<table border="1" cellpadding="1" cellspacing="0">\n};
print qq{<tr><th>Variable Name</th><th>Value</th></tr>\n};

foreach my $k (sort (keys %ENV)) {
	my $v = $ENV{$k};
	print "<tr><td>$k</td><td>$v</td></tr>\n";
}

print qq{</table>\n};


print "<h1>Cookies</h1>\n";

print qq{<table border="1" cellpadding="1" cellspacing="0">\n};
print qq{<tr><th>Variable Name</th><th>Value</th></tr>\n};

my @list = $cgi->cookie();

foreach my $k (sort @list) {
	my $v = $cgi->cookie($k);
	print "<tr><td>$k</td><td>$v</td></tr>\n";
}

print qq{</table>\n};
print qq{</body></html>\n};

exit(0);
