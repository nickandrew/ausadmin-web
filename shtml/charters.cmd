#!/usr/bin/perl

chdir "Charters";
for $i (<*>) {
	print "<li><a href=\"Charters/$i\">$i</a>\n";
}
