package Hastu::Authentication::Credential::Google;

use 5.006;
use Moose 2.0602;
use MooseX::Types::Moose 0.27 qw/Bool HashRef/;

use Catalyst::Exception;
# use URI 1.60;
# use LWP::UserAgent 6.02;
# use HTTP::Request::Common 6.00 qw/POST/;
use JSON 2.53 qw/from_json/;
use Net::OAuth2::Profile::WebServer;
use namespace::autoclean;

use Data::Dump qw/dump/;

our $VERSION = '0.04';

has verbose => (is => 'ro', isa => Bool, default => 0);

has providers => (is => 'ro', isa => HashRef, required => 1);

has scope => (
	      is => 'ro', 
	      isa => 'Str', 
	      # required => 1,
	     );
has auth => (
	     is => "rw",
	     isa => 'Net::OAuth2::Profile::WebServer'
);

sub BUILDARGS {
    my ($self, $config, $c, $realm) = @_;

    return $config;
}

sub BUILD {
      my $self = shift;
      my $args = shift;

      $self->auth(Net::OAuth2::Profile::WebServer->new
		  ( 
		   client_id         => '1042989076422-g03hljhmda7jne9jot3j526taf77i345.apps.googleusercontent.com',
		   client_secret     => 'iVDphllBU8pE-5jYMVZkytOH',
		   site              => 'https://accounts.google.com', 
		   scope             => 'https://www.googleapis.com/auth/plus.login https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile', 
		   authorize_path    => '/o/oauth2/auth',
		   access_token_path => '/o/oauth2/token',
		   redirect_uri      => 'http://hastu.herokuapp.com/google/inst',
		  )
		 )
  }


sub authenticate {
    my ($self, $c, $realm, $auth_info) = @_;

    $c->log->info("auth_info:\n" . dump $auth_info);
    $c->log->info("store:\n" . dump $realm->store);
    $c->log->info("provider:\n" . dump $self->providers->{$auth_info->{provider}});

    # $c->log->info("api_uri:\n" . dump $self->api_uri);
    # $c->log->info("auth:\n" . dump $self->auth);
    
    # $c->res->redirect("http://www.google.com");
    $c->res->redirect($self->auth->authorize);


    $c->detach;
}

1;
