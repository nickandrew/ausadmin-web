#!/usr/bin/perl
#	Emit a series of links to newsgroups scheduled for deletion

# $Revision$
# $Date$


chdir "Deletions";
$count = 0;
for $i (<*>) {
	print "<li><a href=\"Deletions/$i\">$i</a>\n";
	$count++;
}

if ($count == 0) {
	print "<li>None at present\n";
}
