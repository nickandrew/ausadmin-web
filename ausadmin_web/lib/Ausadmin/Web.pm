#!/usr/bin/perl

package Ausadmin::Web;

use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
	my $self = shift;

	$self->app->secrets(['El Mojo Application']);

	# Router
	my $r = $self->routes;

	# Normal route to controller
	$r->get('/')->to('main#welcome');
	$r->get('/under_construction')->to('main#under_construction');

	$r->get('/article_rate_png.cgi')->to('newsgroup#article_rate');
	$r->get('/groupinfo.cgi/*newsgroup')->to('newsgroup#groupinfo');

	# Moved Permanently to new location

	$r->get('/checkgroups.shtml')->to(cb => sub {
		my $c = shift;
		$c->res->code(301);
		$c->redirect_to('/checkgroups.txt');
	});

	$r->get('/vote-list.shtml')->to(cb => sub {
		my $c = shift;
		$c->res->code(301);
		$c->redirect_to('/vote_results');
	});

	$r->get('/vote-results.shtml')->to(cb => sub {
		my $c = shift;
		$c->res->code(301);
		$c->redirect_to('/vote_results');
	});

	# Things still not yet implemented

	$r->get('/grouplist.shtml')->to('main#not_implemented');
	$r->get('/proposal.cgi')->to('main#not_implemented');
	$r->get('/proposal.php')->to('main#not_implemented');
	$r->get('/vote_results')->to('main#not_implemented');

}

1;
