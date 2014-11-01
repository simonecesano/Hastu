package Hastu::Controller::Google;
use Moose;
use namespace::autoclean;

use Net::OAuth2::Profile::WebServer;
use Data::Dump qw/dump/;

BEGIN { extends 'Catalyst::Controller'; }

#----------------------
# this one works
#----------------------

my $auth = Net::OAuth2::Profile::WebServer->new
    ( 
     name              => 'Google Contacts',
     client_id         => '1042989076422-g03hljhmda7jne9jot3j526taf77i345.apps.googleusercontent.com',
     client_secret     => 'iVDphllBU8pE-5jYMVZkytOH',
     site              => 'https://accounts.google.com', 
     scope             => 'https://www.google.com/m8/feeds/',
     authorize_path    => '/o/oauth2/auth',
     access_token_path => '/o/oauth2/token',
     redirect_uri      => 'http://hastu.herokuapp.com/google/inst',
     protected_resource_url
        =>  'https://www.google.com/m8/feeds/contacts/default/full'    );


sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    
    $c->response->body('Matched Hastu::Controller::Google in Google.');
}

sub login :Path('login') {
    my ($self, $c) = @_;
    $c->res->redirect($auth->authorize);
}

sub inst :Path('inst') {
    my ($self, $c) = @_;

    if (1) {
	my $access_token  = $auth->get_access_token($c->req->params->{code});
	$c->res->body(join "\n", '<pre>', (dump $access_token), '</pre>');
    }
    if (0) {
	my $code = $c->req->params->{code};
	$c->res->body($code);
    }
}




1;
