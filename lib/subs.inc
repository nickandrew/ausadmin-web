<?php

function files_in_dir ($dirname) {

	$handle = opendir($dirname);
	if ($handle == false) {
		print "Oops! dir $dirname does not exist!\n";
		return;
	}

	while ($file = readdir($handle)) {
		if ($file == '.' || $file == '..') {
			continue;
		}
		# echo "file read was: $file<br>\n";
		$array[] = $file;
	}

	closedir($handle);

	return $array;
}

function get_ngline ($ng) {
	global	$AUSADMIN_HOME;

	# Look in ~/data/Newsgroups/$ng/ngline
	# Then look in ~/vote/$ng/ngline:$ng
	# Then look in ~/vote/$ng/ngline

	$files = array(
		"$AUSADMIN_HOME/data/Newsgroups/$ng/ngline",
		"$AUSADMIN_HOME/vote/$ng/ngline:$ng",
		"$AUSADMIN_HOME/vote/$ng/ngline"
	);

	foreach ($files as $fn) {
		if (file_exists($fn)) {
			$fp = fopen($fn, "r");
			break;
		}
	}

	if ($fp == false) {
		return false;
	}

	$line = fgets($fp, 120);
	$line = trim($line);

	fclose($fp);

	return $line;
}

function get_charter ($ng) {
	global	$AUSADMIN_HOME;

	# Look in ~/data/Newsgroups/$ng/charter
	# Then look in ~/vote/$ng/charter:$ng
	# Then look in ~/vote/$ng/charter
	# Then look in ~/Charters/$ng
	# Then look in /var/www/aus.news-admin.org/Charters/$ng

	$h = $AUSADMIN_HOME;
	$w = "/var/www/aus.news-admin.org";

	$files = array(
		"$h/data/Newsgroups/$ng/charter",
		"$h/vote/$ng/charter:$ng",
		"$h/vote/$ng/charter",
		"$h/Charters/$ng",
		"$w/Charters/$ng"
	);

	foreach ($files as $fn) {
		if (file_exists($fn)) {
			$fp = fopen($fn, "r");
			break;
		}
	}

	if ($fp == false) {
		# Couldn't find a charter anywhere
		return false;
	}

	$contents = fread($fp, 16384);
	$contents = nl2br($contents);

	fclose($fp);

	return $contents;
}

function get_rfd ($ng) {
	global	$AUSADMIN_HOME;

	# Then look in ~/vote/$ng/result
	# Then look in ~/vote/$ng/cfv
	# Then look in ~/vote/$ng/rfd
	# Then look in ~/vote/$ng/rfd.unsigned

	$h = $AUSADMIN_HOME;

	$files = array(
		"$h/vote/$ng/result",
		"$h/vote/$ng/cfv",
		"$h/vote/$ng/rfd",
		"$h/vote/$ng/rfd.unsigned",
	);

	foreach ($files as $fn) {
		if (file_exists($fn)) {
			$fp = fopen($fn, "r");
			break;
		}
	}

	if ($fp == false) {
		# Couldn't find one anywhere
		return false;
	}

	$contents = fread($fp, 32768);
	$contents = nl2br($contents);

	fclose($fp);

	return $contents;
}

# Return a newsgroup's parent name, unless the newgroup has only 2
# qualifiers (in which case return the newsgroup itself)

function get_ng_prefix ($ng) {

	$l = strpos($ng, '.');
	$r = strrpos($ng, '.');
	$parent = $ng;
	if ($l != $r) {
		$parent = substr($ng, 0, $r);
	}

	return $parent;
}

function print_group_list ($string, $array) {
	echo "<p>\n";
	echo "<b>$string</b><br>\n";

	foreach ($array as $g) {
		echo "&nbsp;&nbsp;<a href=\"/groupinfo.php/$g/\">$g</a><br>\n";
	}
	echo "</p>\n";
}

?>
