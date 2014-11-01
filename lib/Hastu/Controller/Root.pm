package Hastu::Controller::Root;
use Moose;
use namespace::autoclean;

use Data::Dumper;
use Data::Dump qw/dump/;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => '');


sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

1;

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    # Hello World
    $c->stash->{template} = 'index.tt2';
    $c->forward('View::HTML');
}


sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}



sub login :Path('/login') {
    my ($self, $c) = @_;

    $c->authenticate({ provider => 'google.com' });
    $c->log->info();
    $c->res->body('hello');
}

sub welcome :Path('/welcome') {
    my ($self, $c) = @_;

    $c->res->body('welcome: '. dump $c->user);
}

sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

1;

__DATA__

sub oauth2 : Local {
    my ($self, $c) = @_;
    if( $c->authenticate( { provider => 'google.com' } ) ) {
	$c->log->info('something worked');
	#do something with $c->user
    }
}
