<?php

#	@(#) proposal_class.inc - A newsgroup change proposal class
#

require_once('lib/subs.inc');

class Proposal {
	var $name;
	var $proposal_dir;

	function is_active() {
		global	$AUSADMIN_HOME;

		# For a proposal to be linked it must be:
		#	(1) rfd posted (rfd_posted.cfg exists)
		#	(2) not abandoned (rfd_cancel.cfg exists if abandoned)
		#	(3) vote not abandoned (vote_cancel.cfg exists if abandoned)
		#	(4) vote not completed (result_posted.cfg exists if completed)

		$d = "$AUSADMIN_HOME/$this->proposal_dir/$this->name";

		if (! file_exists("$d/rfd_posted.cfg")) {
			# Not posted yet, so hide
			return false;
		}

		if (file_exists("$d/vote_cancel.cfg")) {
			# Vote was cancelled, so ignore it
			return false;
		}

		if (file_exists("$d/rfd_cancel.cfg")) {
			# RFD was cancelled, so ignore it
			return false;
		}

		if (file_exists("$d/result_posted.cfg")) {
			# RFD was completed, so dont show
			return false;
		}

		return true;

	}

	function is_running() {
		global	$AUSADMIN_HOME;

		# For a proposal to be a running vote it must be:
		#	(1) rfd posted (rfd_posted.cfg exists)
		#	(2) not abandoned (rfd_cancel.cfg exists if abandoned)
		#	(3) vote not abandoned (vote_cancel.cfg exists if abandoned)
		#	(4) vote not completed (result_posted.cfg exists if completed)

		$d = "$AUSADMIN_HOME/$this->proposal_dir/$this->name";

		if (file_exists("$d/vote_cancel.cfg")) {
			# Cancelled, forget it
			return false;
		}

		if (file_exists("$d/result")) {
			# Result has been computed
			return false;
		}

		if (file_exists("$d/result.unsigned")) {
			# Result has been computed
			return false;
		}

		if (! file_exists("$d/endtime.cfg")) {
			# Never became a vote
			return false;
		}

		return true;

	}

	function get_vote_endtime() {
		global	$AUSADMIN_HOME;

		$d = "$AUSADMIN_HOME/$this->proposal_dir/$this->name";

		return read_one_line("$d/endtime.cfg");
	}

	function Proposal($name) {
		$this->name = $name;

		if ($this->proposal_dir == '') {
			$this->proposal_dir = "vote";
		}

	}

}

?>
