<?php
	# @(#) article_rate_month_png.php ... Output PNG image for group article rate (weekly graph)

	require_once('lib/setup.inc');

	$ng = $newsgroup;
	$path = "$AUSADMIN_HOME/Mrtg/$ng-month.png";

	if (!file_exists($path)) {
		Header("Content-type: text/plain");
		print "Sorry, an image for $ng does not exist\n";
		exit();
	}

	$size = filesize($path);
	Header("Content-type: image/png");
	Header("Content-Length: $size");

	readfile($path);
?>
