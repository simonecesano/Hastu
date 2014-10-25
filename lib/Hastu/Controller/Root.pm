package Hastu::Controller::Root;
use Moose;
use namespace::autoclean;

use WebService::Instagram;
use Facebook::Graph;
use Facebook::Graph::AccessToken;
use Net::Google::DataAPI::Auth::OAuth2;
use Data::Dumper;

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


sub oauth2 : Local {
    my ($self, $c) = @_;
    if( $c->authenticate( { provider => 'google.com' } ) ) {
	$c->log->info('something worked');
	#do something with $c->user
    }
}

sub login :Path('/login') {
    my ($self, $c) = @_;

    return $c->res->redirect('/welcome', '302')
		if ($c->authenticate({provider => 'google.com'}));

     $c->log->debug('***Root:auto User not Authenticated');
     $c->res->body('Authentication Error: '. $c->stash->{auth_error});
}

sub welcome :Path('/welcome') {
    my ($self, $c) = @_;

    $c->res->body('welcome: '.$c->user->email);
}

sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

1;
