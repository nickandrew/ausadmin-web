<?php
	# proposals.inc ... figure out if there are any proposals pending
	# and show them as a link

	require_once('lib/setup.inc');
	require_once('lib/subs.inc');
	require_once('lib/proposal_class.inc');

	function running_votes() {
		global	$AUSADMIN_HOME;

		$array = files_in_dir("$AUSADMIN_HOME/vote");

		# For a proposal to be a running vote it must be:
		#	(1) rfd posted (rfd_posted.cfg exists)
		#	(2) not abandoned (rfd_cancel.cfg exists if abandoned)
		#	(3) not complete (result_posted.cfg exists)
		# state file says vote/running
		# endtime.cfg date is not exceeded
		# 

		$active_proposals = array();
		$endtime = array();

		foreach ($array as $fn) {

			$prop = new Proposal($fn);

			if ($prop->is_running()) {
				$active_proposals[] = $fn;
				$endtime[$fn] = $prop->get_vote_endtime();
			}
		}

		if ($active_proposals) {
			echo "<!-- start of votes_running.inc -->\n";
			echo "<p>\n";
			echo "<b>Votes&nbsp;running:</b><br>\n";
			$now = time();
			foreach ($active_proposals as $p) {
				if ($endtime[$p] < $now) {
					# Ignore this one
					continue;
				}
				$ed = floor(($endtime[$p] - $now)/86400);
				$eh = floor(($endtime[$p] - $now)/3600);
				$em = floor(($endtime[$p] - $now)/60);
				$es = ($endtime[$p] - $now);
				$ends = "$es seconds";
				if ($em > 1) {
					$ends = "$em minutes";
				}
				if ($eh > 1) {
					$ends = "$eh hours";
				}
				if ($ed > 1) {
					$ends = "$ed days";
				}
				echo "&nbsp;&nbsp;<a href=\"/proposal.php?proposal=$p\">$p (ends in $ends)</a><br>\n";
			}
			echo "</p>\n";
			echo "<!-- end of votes_running.inc -->\n";
		}
	}

	running_votes();

?>
