<?php
	# proposals.inc ... figure out if there are any proposals pending
	# and show them as a link

	require_once('lib/setup.inc');
	require_once('lib/subs.inc');
	require_once('lib/proposal_class.inc');

	function active_proposals() {
		global	$AUSADMIN_HOME;

		$array = files_in_dir("$AUSADMIN_HOME/vote");

		# For a proposal to be linked it must be:
		#	(1) rfd posted (rfd_posted.cfg exists)
		#	(2) not abandoned (rfd_cancel.cfg exists if abandoned)
		#	(3) not complete (result_posted.cfg exists)

		$active_proposals = array();

		foreach ($array as $fn) {

			$prop = new Proposal($fn);

			if ($prop->is_active()) {
				$active_proposals[] = $fn;
			}
		}

		if ($active_proposals) {
			echo "<!-- start of proposals.inc -->\n";
			echo "<p>\n";
			echo "<b>Proposals:</b><br>\n";
			foreach ($active_proposals as $p) {
				echo "&nbsp;&nbsp;<a href=\"/proposal.php?proposal=$p\">$p</a><br>\n";
			}
			echo "</p>\n";
			echo "<!-- end of proposals.inc -->\n";
		}
	}

	active_proposals();

?>
