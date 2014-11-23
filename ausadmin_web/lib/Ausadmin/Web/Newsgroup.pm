#	Ausadmin::Web::Newsgroup - a newsgroup (existing or not)

=head1 NAME

Ausadmin::Web::Newsgroup - a newsgroup

=head1 SYNOPSIS

 use Ausadmin::Web::Newsgroup;

 $ng = new Newsgroup(name => 'aus.history', hier => $hier);
 $bool = Newsgroup::valid_name('aus.history');
 $bool = Newsgroup::validate('aus.history');

 $flags = $ng->group_flags()  ... return the 'y' or 'm' status of the group
 
 $string = $ng->get_attr('charter') ... Read the charter data, return as string
 $ng->set_attr('charter', $string, 'Update reason') ...

 $string = $ng->gen_newgroup($control_type);	... Create a control msg

 $signed_text = $ng->sign_control($unsigned_text) ... Sign a control msg

 my @newsgroup_list = Newsgroup::list_newsgroups(hier => $hier);
 	# returns a list of newsgroups in that hierarchy

 $ng->create();
	# Creates the directory for a new newsgroup

=cut

package Ausadmin::Web::Newsgroup;

use strict;

use IO::File;
use IPC::Open2;
use Carp qw(confess);

# use Ausadmin;

$Newsgroup::DEFAULT_HIERARCHY	= 'aus';

# ---------------------------------------------------------------------------
# Constructor
# ---------------------------------------------------------------------------

sub new {
	my $class = shift;
	my $self = { @_ };
	bless $self, $class;

	die "No name" if (!exists $self->{name});

	$self->{hier} ||= $Newsgroup::DEFAULT_HIERARCHY;

	return $self;
}

# ---------------------------------------------------------------------------
# Return the data directory for a hierarchy
# ---------------------------------------------------------------------------

sub datadir {
	my $hier = shift;

	return "$ENV{AUSADMIN_HOME}/data/$hier.data";
}

# ---------------------------------------------------------------------------
# Check the newsgroup name for compliance with international newsgroup standards.
# ---------------------------------------------------------------------------

sub valid_name {
	my $ng_name = shift;

	# NOTE ... this allows no single-group hierarchies
	return 1 if ($ng_name =~ /^[a-z0-9+-]+\.[a-z0-9+-]+(\.[a-z0-9+-]+)*$/);

	return 0;
}

# ---------------------------------------------------------------------------
# Check the newsgroup name for compliance with ausadmin naming (including a
# group date at the end, after a colon)
# ---------------------------------------------------------------------------

sub validate {
	my $ng_name = shift;

	return 1 if ($ng_name =~ /^[a-z0-9+-]+\.[a-z0-9+-]+(\.[a-z0-9+-]+)*(:\d\d\d\d-\d\d-\d\d)?$/);
	return 0;
}

# ---------------------------------------------------------------------------
# temp procedure
# ---------------------------------------------------------------------------

sub debug_it {
	my $ref = shift;
	print "Ref is $ref\n";
	foreach my $v (keys %$ref) {
		print "Key: $v ";
		my $l = $ref->{$v};
		foreach (@$l) {
			print " val $_";
		}
		print "\n";
	}
	print "\n";
}

# ---------------------------------------------------------------------------
# Return the directory name containing this newsgroup's attributes
# ---------------------------------------------------------------------------

sub _dirname {
	my $self = shift;

	my $datadir = datadir($self->{hier});
	my $path = "$datadir/Newsgroups/$self->{name}";
	return $path;
}

# ---------------------------------------------------------------------------
# Check if the newsgroup 'exists' as in ausadmin knows about it
# ---------------------------------------------------------------------------

sub is_known {
	my $self = shift;

	my $dir = $self->_dirname();
	return 0 if (!-d $dir);
	return 1;
}

# ---------------------------------------------------------------------------
# Read data from a file, store it in a string and this object's attributes
# ---------------------------------------------------------------------------

sub get_attr {
	my $self = shift;
	my $attr_name = shift;

	return $self->{$attr_name} if (exists $self->{$attr_name});

	my $datadir = datadir($self->{hier});
	my $path = "$datadir/Newsgroups/$self->{name}/$attr_name";
	return undef if (!-f $path);

	my $fh = new IO::File;
	if (!open($fh, "<$path")) {
		die "Unable to open $path: $!\n";
	}

	my $s;

	while (<$fh>) {
		$s .= $_;
	}

	close($fh);

	return $s;
}

sub set_attr {
	my $self = shift;
	my $attr_name = shift;
	my $string = shift;
	my $reason = shift;

	my $datadir = datadir($self->{hier});
	my $path = "$datadir/Newsgroups/$self->{name}/$attr_name";

	my $exists;
	if (-f $path) {
		$exists = 1;
		if (!-f "$datadir/Newsgroups/$self->{name}/RCS/$attr_name,v") {
			# check it in for the first time
			my $rc = system("ci -l $path < /dev/null");
			if ($rc) {
				print "Initial checkin rc $rc\n";
			}
		}
	} else {
		$exists = 0;
	}

	my $fh = new IO::File;
	if (!open($fh, ">$path")) {
		die "Unable to open $path for write: $!\n";
	}

	print $fh $string;
	
	close($fh);

	if ($exists) {
		# Check in an update, with that message
		my $rc = system("ci", "-l", "-m$reason", $path);
		if ($rc) {
			print "checkin existing rc $rc\n";
		}
	} else {
		# Check in initial version, use -t-string
		my $rc = system("ci", "-l", "-t-$reason", $path);
		if ($rc) {
			print "checkin new rc $rc\n";
		}
	}

	# Now write an audit log that we did it ... TODO

	return 0;
}

# ---------------------------------------------------------------------------
# gen_newgroup() ... Generate a newgroup message for this group
# ---------------------------------------------------------------------------

sub gen_newgroup {
	my $self = shift;

	# $control_type = [booster|initial]
	my $control_type = shift || confess('Missing parameter in call to gen_newgroup');

	my $hier_name = $self->{hier_name};
	my $name = $self->{name};

	my $template_path = "config/${control_type}.template";
	my $template2_path = "config/${hier_name}.control.ctl";
	my $datadir = datadir($self->{hier});
	my $ngline_path = "$datadir/Newsgroups/$self->{name}/ngline";

	if (! -f $template_path) {
		confess("$control_type template file does not exist");
	}

	if (! -f $ngline_path) {
		confess("$ngline_path does not exist, required for a newgroup");
	}

	my $template = Ausadmin::readfile($template_path);
	my $control_ctl = Ausadmin::readfile($template2_path);
	my $ngline = Ausadmin::read1line($ngline_path);

	my $moderated = 0;		# FIXME ... a safe assumption!

	my $control;
	my $modname;

	if ($moderated) {
		$control = "newgroup $name m";
		$modname = "a moderated";
	} else {
		$control = "newgroup $name";
		$modname = "an unmoderated";
	}

	my $post = eval $template;

	return $post;
}

sub sign_control {
	my $self = shift;
	my $unsigned = shift || confess("No message given to sign_control()");

	# I don't like calling perl code from other perl code. I prefer
	# putting it in a module. But signcontrol is too messy to include
	# verbatim, so I'll just use it as a filter.

	my $fh_r = new IO::File;
	my $fh_w = new IO::File;
	my $pid = open2($fh_r, $fh_w, "signcontrol");

	# Output the unsigned text to the write file handle

	print $fh_w $unsigned;

	# and close it to make the process's output available
	close($fh_w);

	my @return = <$fh_r>;

	return join('', @return);
}

# ---------------------------------------------------------------------------
# Return a list of all newsgroups in the directory
# ---------------------------------------------------------------------------

sub list_newsgroups {
	my $args = { @_ };

	$args->{hier} ||= $Newsgroup::DEFAULT_HIERARCHY;
	my $datadir = datadir($args->{hier});

	if (! $datadir) {
		confess "No datadir";
	}

	# Ignore newsgroup names not containing a dot, and . and ..
	opendir(D, "$datadir/Newsgroups");
	my @files = grep { ! /^\.|^[a-zA-Z0-9-]+$/ } readdir(D);
	closedir(D);

	my @list;

	foreach my $f (sort @files) {
		my $path = "$datadir/Newsgroups/$f";
		next if (! -d $path);
		# It is not a newsgroup if there's no "ngline" file
		# (later) next if (! -f "$path/ngline");
		push(@list, $f);
	}

	return @list;
}

sub create {
	my $self = shift;

	my $datadir = datadir($self->{hier});

	my $dir = "$datadir/Newsgroups/$self->{name}";

	if (!-d $dir) {
		mkdir($dir, 0755);
	}

	if (!-d "$dir/RCS") {
		mkdir("$dir/RCS", 0755);
	}
}

sub defaultHierarchy {
	return $Newsgroup::DEFAULT_HIERARCHY;
}

1;
