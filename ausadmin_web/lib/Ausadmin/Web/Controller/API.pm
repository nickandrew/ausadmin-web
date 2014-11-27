#!/usr/bin/perl

=head1 NAME

Ausadmin::Web::Controller::API - REST API Controller for newsgroups

=head1 METHODS

=over

=cut

package Ausadmin::Web::Controller::API;

use Mojo::Base 'Mojolicious::Controller';

use Ausadmin::Web::Newsgroup qw();

=item I<newsgroups()>

Usage: GET /api/newsgroup

Return a sorted list of all newsgroups

=cut

sub newsgroups {
	my $self = shift;

	my @newsgroup_list = Ausadmin::Web::Newsgroup::list_newsgroups();

	$self->render(json => \@newsgroup_list);
}

=item I<newsgroup()>

Usage: GET /api/newsgroup/*newsgroup

Return all attributes of specified newsgroup

=cut

sub newsgroup {
	my $self = shift;

	my $newsgroup = $self->stash('newsgroup');

	if (!Ausadmin::Web::Newsgroup::valid_name($newsgroup)) {
		$self->app->log->warn("Bad newsgroup name $newsgroup");
		return $self->render(status => 404);
	}

	my $ng = Ausadmin::Web::Newsgroup->new(name => $newsgroup);
	if (!$ng) {
		$self->app->log->warn("Unable to instantiate Ausadmin::Web::Newsgroup for $newsgroup");
		return $self->render(status => 404);
	}

	if (!$ng->is_known()) {
		$self->app->log->info("No such newsgroup $newsgroup");
		return $self->render(status => 404);
	}

	my $charter = $ng->get_attr('charter') || '';

	my $ngline = $ng->get_attr('ngline') || '';
	chomp($ngline);

	return $self->render(json => { newsgroup => $newsgroup, ngline => $ngline, charter => $charter });
}

=back

=cut

1;
