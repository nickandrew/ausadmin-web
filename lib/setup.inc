<?php
	global	$AUSADMIN_HOME;
	global	$AUSADMIN_DATA;
	global	$AUSADMIN_HIER;

	$AUSADMIN_HOME = "/home/ausadmin";
	$AUSADMIN_DATA = "/home/ausadmin/data";
	$AUSADMIN_HIER = "aus";

	# Provide a way to override the hierarchy based on hostname
	if ($HTTP_HOST != '') {
		$l = strpos($HTTP_HOST, '.');
		if ($l > 0) {
			$AUSADMIN_HIER = substr($HTTP_HOST, 0, $l);
		}
	}

	if ($AUSADMIN_HIER == 'aus') {
		$AUSADMIN_DATA = "$AUSADMIN_HOME/data";
	} else {
		$AUSADMIN_DATA = "$AUSADMIN_HOME/$AUSADMIN_HIER.data";
	}

?>
