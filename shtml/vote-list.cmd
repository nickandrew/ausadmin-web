#!/usr/bin/perl
# Generates a list items "<li>" with links to the CFV for currently 
# running votes, and a results page for finished votes.
#
# $Revision$
# $Date$

$HREF="/cgi-bin/voteinfo?newsgroup=";

# Run with $ARGV[0] == 0 => vote completed or cancelled
# Run with $ARGV[0] == 1 => vote still running
# Run with $ARGV[0] == 2 => rfd received, no vote yet

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
	my $group = shift;

	if (-f "$group/vote_cancel.cfg") {
		return 0;
	} elsif ( open( CONFIGFILE, "$group/endtime.cfg") ) {
		chomp( $_ = <CONFIGFILE> );
		my $VE = $_;
		close( CONFIGFILE );
		if ( $VE > time ) {
			return 1;
		}
		else {
			return 0;
		}
	} elsif (-f "$group/rfd") {
		return 2;
	} else {
		return 0;
	}
}
