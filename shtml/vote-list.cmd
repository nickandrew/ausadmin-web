#!/usr/bin/perl
# Generates a list items "<li>" with links to the CFV for currently 
# running votes, and a results page for finished votes.
#
# $Revision$
# $Date$

$HREF="/cgi-bin/voteinfo?newsgroup=";

# Run with $ARGV[0] == 0 => vote completed
# Run with $ARGV[0] == 1 => vote still running

chdir( "../vote" );
if ( open( LSOUTPUT, "ls -dw1 *.*|" ) ) {
	while( <LSOUTPUT> ) {
		chomp;
		$Newsgroup = $_;
		if ( CheckGroup( $_ ) == $ARGV[0] ) {
			print "<li><a href=\"$HREF$Newsgroup\">$Newsgroup</a></li>\n";
		}
	}
	close( LSOUTPUT );
}
else {
	die "Couldn't do an LS";
}

# Checks to see if a group vote is still running (1) or not (0)
sub CheckGroup {
	if ( open( CONFIGFILE, "$_[0]/endtime.cfg") ) {
		chomp( $_ = <CONFIGFILE> );
		$VE = $_;
		close( CONFIGFILE );
	}
	else {
		return 0;
	}
	if ( $VE > time ) {
		return 1;
	}
	else {
		return 0;
	}
}
