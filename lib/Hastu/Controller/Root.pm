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

has google => ( is => 'rw', lazy => 1, builder => '_google' );
has redirect => ( is => 'rw', lazy => 1, builder => '_redirect' );


sub _redirect {
    my ( $self, $c ) = @_;
    my $redirect_uri = $ENV{'REDIRECT_URI'} || 'http://hastu.herokuapp.com/oauth2callback';
    return $redirect_uri;
}

# Google API token generation only. Request /google
sub _google {
    my ( $self, $c ) = @_;
    return Net::Google::DataAPI::Auth::OAuth2->new({
        client_id => $ENV{'GOOGLE_CLIENT_ID'} || '1042989076422-g03hljhmda7jne9jot3j526taf77i345.apps.googleusercontent.com',
        client_secret => $ENV{'GOOGLE_CLIENT_SECRET'} || 'ioZUgU_A4yg6xb2F6CfQcTb6 ',
        scope => ['https://www.google.com/calendar/feeds/'],
        redirect_uri => $self->redirect,
    });
}

sub google_generatetokenid :Path('/google') :Args(0) {
    my ( $self, $c ) = @_;
    $c->res->redirect($self->google->authorize_url());
    $c->detach();
}

sub google_inst :Path('/google/inst') :Args() {
    my ( $self, $c ) = @_;
    my $code = $c->req->param('code');
    if ( defined $code ) {
        $c->forward('google_gettoken', [ $code ] );
        $c->detach();
    }
    $c->res->body("Code not found");
}

sub google_gettoken :Path('/google/gettoken') :Args(1) {
    my ( $self, $c, $code ) = @_;
    my $access_token = $self->google->get_access_token($code);
    $c->res->body("access_token: ".$access_token->{NOA_access_token}."<br>refresh_token: ".$access_token->{NOA_refresh_token});
    $c->detach();
}

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


sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

1;
