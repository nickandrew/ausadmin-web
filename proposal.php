<?php
	# @(#) proposal.php ... Show one proposal

	require_once('lib/setup.inc');
	require_once('lib/subs.inc');
	require_once('lib/proposal_class.inc');

	# Get the newsgroup name
	$x = apache_lookup_uri($REQUEST_URI);
	$y = $x->path_info;

	# $y ... "/newsgroup_name/something"

	$ng = $proposal;

	if (file_exists("$AUSADMIN_HOME/vote/$ng")) {
		# Read it and weep
		$rfd = get_rfd($ng);
	}


	if ($rfd == false) {
		# Substitute ...
		$rfd = "No RFD is available for this group, sorry!<br>\n";
	}

?>

<html>
 <head>
  <title>Newsgroup <?php echo $ng ?> </title>
 </head>
 <body>
  <table border="1" bgcolor="#ffffe0" cellspacing="0" cellpadding="3" width="98%">
   <tr>
    <td width="080" valign="top">
     <font size=-1>
      <?php require("lib/ausadmin_hdr.inc"); ?>
      <?php require("lib/proposals.inc"); ?>

     </font>
    </td>
    <td>
     <center><h1>Proposal <?php echo $ng ?></h1></center>
     <hr>
       <?php echo $rfd ?>
    </td>
   </tr>
  </table>
 </body>
</html>

