#!/usr/bin/perl
#	@(#) deletions.cmd - Emit a series of links to newsgroups scheduled for deletion
#
# $Source$
# $Revision$
# $Date$


chdir "Deletions";
$count = 0;
for $i (<*>) {
	next if ($i !~ /\./);
	print "<li><a href=\"Deletions/$i\">$i</a>\n";
	$count++;
}

if ($count == 0) {
	print "<li>None at present\n";
}

exit(0);
