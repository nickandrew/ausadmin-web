#!/usr/bin/perl -w
#	@(#) $Header$
#	vim:sw=4:ts=4:
#
#	Ausadmin new username registration script
#

use strict;

use CGI qw();

use Ausadmin::CookieSet qw();

my $cgi = new CGI();
my $cookies = Ausadmin::CookieSet->new($cgi);

my $id = $cookies->getID();

$cookies->idCookie();

print CGI::header(
	-type => 'text/html',
	-status => '200 OK',
	-expires => '+0m',
	-cookie => $cookies->getList(),
);

print <<EOF;
<!DOCTYPE html PUBLIC "-//W3C/DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
<link type="text/css" rel="stylesheet" href="style.css" />

<title>aus.* newsgroups administration (hello $id)</title>
</head>
<body>
EOF

if (! $id) {
	print "You need cookies enabled in order to register.\n";
} else {
	print <<EOF;
<pre>
Why register with ausadmin?

 - you can submit proposals
 - you can vote on proposals

Privacy Policy

 - identifying information is retained
 - will never be given to third parties, except as required by law

</pre>

<form method="POST">
<table border="1" cellpadding="2" cellspacing="0">
<tr>
 <td>Desired username</td>
 <td><input name="username" size="20" maxlength="16"> (max 16 chars)</td>
</tr>

<tr>
 <td>Choose Password</td>
 <td><input name="password" type="password" size="20" maxlength="16"> (max 16 chars)</td>
</tr>

<tr>
 <td>Confirm Password</td>
 <td><input name="password" type="password" size="20" maxlength="16"> (max 16 chars)</td>
</tr>

<tr>
 <td colspan="2">
   Email address is used to verify your identity. A confirming message
   will be sent to your address, and you need to visit the address
   contained in the message to confirm your identity.
 </td>
</tr>

<tr>
 <td>Email Address</td>
 <td><input name="email" size="32" maxlength="64"> (max 64 chars)</td>
</tr>

<tr>
 <td colspan="2">
  <input type="submit" value="Register">
 </td>
</tr>

</table>
</form>
EOF

}


print <<EOF;
</body>
</html>
EOF

exit(0);
