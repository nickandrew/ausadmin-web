#!/usr/bin/perl

package Ausadmin::Web;

use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
	my $self = shift;

	# Router
	my $r = $self->routes;

	# Normal route to controller
	$r->get('/')->to('main#welcome');
	$r->get('/groupinfo.cgi/*newsgroup')->to('newsgroup#groupinfo');

	$r->get('/checkgroups.shtml')->to(cb => sub {
		my $c = shift;
		$c->res->code(301);
		$c->redirect_to('/checkgroups.txt');
	});
}

1;
