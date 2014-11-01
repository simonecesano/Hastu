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

sub login :Path('login') {
    my ($self, $c) = @_;
    $c->res->redirect($c->model('Google')->authorize);
}

sub inst :Path('inst') {
    my ($self, $c) = @_;

    $c->log->info(ref $c->model('Google'));

    my $token = $c->model('Google')->get_access_token($c->req->params->{code});
    $c->log->info("session freeze:\n" . dump $token->session_freeze);
    $c->session->{tokens}->{google} = $token->session_freeze;

    $token = Net::OAuth2::AccessToken->session_thaw($c->session->{tokens}->{google}, profile => $c->model('Google'));

    my $response = $c->model('Google')->request_auth($token, GET => 'https://www.googleapis.com/oauth2/v2/userinfo');
    $c->res->body(join "\n", '<pre>', ($response->content), '</pre>');
}

sub name :Path('name') {
    my ($self, $c) = @_;
    $c->res->body(join "\n", '<pre>', (dump $c->session->{token}), '</pre>');
    # $c->res->body(join "\n", '<pre>', (dump $c->session->{token}), '</pre>');
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
