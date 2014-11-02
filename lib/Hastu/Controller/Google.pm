package Hastu::Controller::Google;
use Moose;
use namespace::autoclean;

use Net::OAuth2::Profile::WebServer;
use Data::Dump qw/dump/;

BEGIN { extends 'Catalyst::Controller'; }

#----------------------#
# this one works       #
#----------------------#

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    
    $c->response->body('Matched Hastu::Controller::Google in Google.');
}
use JSON::XS qw/decode_json/;

sub login_google :Path('/login/google') {
    my ($self, $c) = @_;
    unless ($c->req->params->{code}) {
	$c->authenticate({ provider => 'google.com' });
	# $c->res->redirect($c->model('Google')->authorize);
    } else {
	$c->authenticate({ provider => 'google.com' });
	#------------------------------
	# need to redirect somewhere
	#------------------------------
	$c->res->body('authenticated! "'. $c->user->name . '"');
    }
}

sub login_fb :Path('/login/fb') {
    my ($self, $c) = @_;
    unless ($c->req->params->{code}) {
	$c->authenticate({ provider => 'facebook.com' });
    } else {
	$c->authenticate({ provider => 'facebook.com' });
	#------------------------------
	# need to redirect somewhere
	#------------------------------
	$c->res->body('authenticated! "'. $c->user->name . '"');
    }
}


1;

__DATA__


https://www.googleapis.com/plus/v1/people/me

SCOPES
======

my $auth = Net::OAuth2::Profile::WebServer->new
    ( 
     name              => 'Google Contacts',
     client_id         => '1042989076422-g03hljhmda7jne9jot3j526taf77i345.apps.googleusercontent.com',
     client_secret     => 'iVDphllBU8pE-5jYMVZkytOH',
     site              => 'https://accounts.google.com', 
     scope             => join " ", 
     qw|https://www.googleapis.com/auth/plus.login 
        https://www.googleapis.com/auth/plus.me
        https://www.googleapis.com/auth/userinfo.email
        https://www.googleapis.com/auth/userinfo.profile|, 
     authorize_path    => '/o/oauth2/auth',
     access_token_path => '/o/oauth2/token',
     redirect_uri      => 'http://hastu.herokuapp.com/google/inst',
     protected_resource_url
        =>  'https://www.google.com/m8/feeds/contacts/default/full'    );
