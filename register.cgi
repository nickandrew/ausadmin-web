#!/usr/bin/perl -w
#	@(#) $Header$
#	vim:sw=4:ts=4:
#
#	Ausadmin new username registration script
#

use strict;

use CGI qw();
use CGI::Carp qw(fatalsToBrowser);
use Date::Format qw(time2str);

use Ausadmin qw();
use Ausadmin::CookieSet qw();
use Ausadmin::Email qw();

my $cgi = new CGI();
my $sqldb = Ausadmin::sqldb();

my $cookies = Ausadmin::CookieSet->new($cgi, $sqldb);

# Log who visited where
$cookies->logIdent();

my $id = $cookies->getIDToken();
my $username = $cookies->getUserName();

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

<title>ausadmin registration (hello $id, $username)</title>
</head>
<body>
EOF

my $action = $cgi->param('action') || '';

if (! $id) {
	print "You need cookies enabled in order to register.\n";
}
elsif ($username) {
	print "You are already logged in, you cannot register again!\n";
}
elsif ($action eq 'verify') {
	doVerify();
}
elsif ($action eq 'register') {
	doRegister();
}
else {
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
<input type="hidden" name="action" value="register" />
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
 <td><input name="confirm_password" type="password" size="20" maxlength="16"> (max 16 chars)</td>
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

# ---------------------------------------------------------------------------
# Register - i.e. add our details to the pending_registrations table
# ---------------------------------------------------------------------------

sub doRegister {

	my $username = $cgi->param('username');
	my $password = $cgi->param('password');
	my $confirm_password = $cgi->param('confirm_password');
	my $email = $cgi->param('email');

	if (! $username || $username !~ /^[a-zA-Z0-9_!-\/-]+$/ || length($username) > 16) {
		die "Invalid username $username";
	}

	if (! $password) {
		die "Invalid password";
	}
	elsif (! $confirm_password) {
		die "Invalid confirm password";
	}
	elsif ($password ne $confirm_password) {
		die "Confirm password does not match password";
	}

	if (! $email || $email !~ /\@/) {
		die "Invalid email $email\n";
	}

	my $xuser = $sqldb->fetch1("select username from user where username = ?", $username);

	if ($xuser) {
		die "Cannot register as $username because it already exists";
	}

	$xuser = $sqldb->fetch1("select username from pending_registration where username = ?", $username);

	if ($xuser) {
		die "Cannot register as $username because it is currently pending registration";
	}

	my $now = time2str('%Y-%m-%d %T', time());
	my $future = time2str('%Y-%m-%d %T', time() + 2 * 86400);

	my $verify_string = Ausadmin::CookieSet::randomValue(16);

	$sqldb->insert('pending_registration',
		username => $username,
		password => $password,
		email_address => $email,
		verify_string => $verify_string,
		created_on => $now,
		expires_on => $future,
	);

	$sqldb->commit();

	my $msg = Ausadmin::Email->new(
		template => 'registration.email'
	);

	my $args = {
		RECIPIENTS => $email,
		AUSADMIN_URL => 'http://aus.news-admin.org/',
		REGISTRATION_URL => "http://aus.news-admin.org/register.ci?action=verify;confirm=$verify_string",
	};

	$msg->send( [$email], $args);

	print "An email has been sent to $email, containing a URL which you need to go to, in order to complete your registration.\n";
}

# ---------------------------------------------------------------------------
# doVerify - i.e. complete a registration process and login the user.
# ---------------------------------------------------------------------------

sub doVerify {
	my $confirm = $cgi->param('confirm');

	if (! $confirm) {
		die "Invalid confirmation code";
	}

	my $rows = $sqldb->extract("select username, password, email_address from pending_registration where verify_string = ?", $confirm);

	if (! $rows || ! $rows->[0]) {
		die "Invalid confirmation code";
	}

	# Success!
	my $row = $rows->[0];
	my ($username, $password, $email_address) = @$row;

	my $now = time2str('%Y-%m-%d %T', time());

	$sqldb->insert('user',
		username => $username,
		password => $password,
		active => 1,
		email_address => $email_address,
		created_on => $now,
	);

	$sqldb->execute("delete from pending_registration where verify_string = ?", $confirm);

	$sqldb->commit();

	my $uri_prefix = Ausadmin::config('uri_prefix');

	# TODO ... I should be able to login as $username here

	print "You have now successfully registered as $username. Welcome to ausadmin!\n";
	print <<EOF;
<a href="$uri_prefix">Enter main site</a>
EOF

}

