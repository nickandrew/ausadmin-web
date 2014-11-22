#!/usr/bin/perl

package Ausadmin::Web::Controller::Newsgroup;

use Mojo::Base 'Mojolicious::Controller';

use Ausadmin::Web::Include qw();
use Ausadmin::Web::Newsgroup qw();

# This action will render a template

sub groupinfo {
	my $self = shift;

	# Fix AUSADMIN_DATA
	my $hier = 'aus';
	$ENV{AUSADMIN_DATA} = "$ENV{AUSADMIN_HOME}/data/${hier}.data";

	# Render template "example/welcome.html.ep" with message
	my $newsgroup = $self->stash('newsgroup');

	if ($newsgroup =~ /\//) {
		# Remove anything following a slash
		$newsgroup =~ s/\/.*//;
		$self->stash('newsgroup', $newsgroup);
	}

	my $ngroup = Ausadmin::Web::Newsgroup->new(name => $newsgroup);
	if (!$ngroup) {
		$self->render(status => 404);
		return;
	}

	$self->stash('ngline', $ngroup->get_attr('ngline') || "");
	$self->stash('charter', $ngroup->get_attr('charter') || "No charter is available for the group $newsgroup, sorry!");
	$self->newsgroupList();
	$self->relatedVotesList($newsgroup);

	# Header links
	my $lines_ref = Ausadmin::Web::Include::html('header-links.html');
	if ($lines_ref) {
		my $template = join('', @$lines_ref);
		my $string = $self->render_to_string(inline => $template);
		$self->stash('header_links' => $string);
	} else {
		$self->stash('header_links' => 'Cannot read header-links');
	}

	$self->render(msg => "Newsgroup $newsgroup");
}

sub relatedVotesList {
	my $c = shift;
	my $ng = shift;

	my @contents;

	my $parent = $ng;
	$parent =~ s/\.[^.]+$//;

	my @newsgroup_list = Ausadmin::Web::Newsgroup::list_newsgroups();
	my @siblings;

	foreach my $fn (sort @newsgroup_list) {
		if ($fn =~ /^$parent/) {
			push(@siblings, $fn);
		}
	}

	if (!@siblings) {
		$c->stash(related_groups => '<br/>');
		return;
	}

	# FIXME
	push(@contents, "<b>See Also:</b><br />");

	my $base = $c->url_for('/groupinfo.cgi');

	foreach my $n (@siblings) {
		push(@contents, "&nbsp;&nbsp;<a href=\"$base/$n\">$n</a><br />\n");
	}

	$c->stash(related_groups => join('', @contents));
}

sub newsgroupList {
	my ($c) = @_;

	my @newsgrouplist = Ausadmin::Web::Newsgroup::list_newsgroups();

	if (!@newsgrouplist) {
		@newsgrouplist = qw(aus.abc aus.sbs aus.test aus.xyz);
	}

	my $base = $c->url_for('/groupinfo.cgi');

	my @content;

	push(@content, "<p><b>Newsgroups:</b><br />\n");

	foreach my $g (@newsgrouplist) {
		my $s = "&nbsp;&nbsp;<a href=\"$base/$g\">$g</a><br />\n";
		push(@content, $s);
	}

	push(@content, "</p>");

	$c->stash(newsgroup_list => join('', @content));
}

1;
