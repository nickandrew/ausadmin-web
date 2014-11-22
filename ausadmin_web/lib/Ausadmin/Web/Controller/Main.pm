#!/usr/bin/perl

package Ausadmin::Web::Controller::Main;

use Mojo::Base 'Mojolicious::Controller';

use Ausadmin::Web::Include qw();
use Ausadmin::Web::Newsgroup qw();

# This action will render a template
sub welcome {
	my $self = shift;

	# Fix AUSADMIN_DATA
	my $hier = 'aus';
	$ENV{AUSADMIN_DATA} = "$ENV{AUSADMIN_HOME}/data/${hier}.data";

	my $lines_ref = Ausadmin::Web::Include::html('header-links.html');
	if ($lines_ref) {
		my $template = join('', @$lines_ref);
		my $string = $self->render_to_string(inline => $template);
		$self->stash('header_links' => $string);
	} else {
		$self->stash('header_links' => 'Cannot read header-links');
	}
	$self->newsgroupList();

	# Render template "example/welcome.html.ep" with message
	$self->render(msg => 'Welcome to the Mojolicious real-time web framework!');
}

sub newsgroupList {
	my ($c) = @_;

	my @newsgrouplist = Ausadmin::Web::Newsgroup::list_newsgroups();

	if (!@newsgrouplist) {
		@newsgrouplist = qw(aus.abc aus.sbs aus.test aus.xyz);
	}

	my $base = $c->url_for('/groupinfo.cgi');

	my @content;

	push(@content, "<b>Newsgroups:</b><br />\n");

	foreach my $g (@newsgrouplist) {
		my $s = "&nbsp;&nbsp;<a href=\"$base/$g\">$g</a><br />\n";
		push(@content, $s);
	}

	$c->stash(newsgroup_list => join('', @content));
}

1;
