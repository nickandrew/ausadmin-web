#!/usr/bin/perl

chdir "Deletions";
for $i (<*>) {
	print "<li><a href=\"Deletions/$i\">$i</a>\n";
}
