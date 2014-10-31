package Hastu::Authentication::Credential::Google;
#package Yxes::Catalyst::Authentication::Credential::Google;

use 5.006;
use Moose 2.0602;
use MooseX::Types::Moose 0.27 qw/Bool HashRef/;

use Catalyst::Exception;
use URI 1.60;
use LWP::UserAgent 6.02;
use HTTP::Request::Common 6.00 qw/POST/;
use JSON 2.53 qw/from_json/;

use namespace::autoclean;

use Data::Dump qw/dump/;

our $VERSION = '0.04';

has verbose => (is => 'ro', isa => Bool, default => 0);

has providers => (is => 'ro', isa => HashRef, required => 1);

has scope => (
	      is => 'ro', 
	      isa => 'Str', 
	      required => 1,
	      default => sub { 'https://www.googleapis.com/auth/userinfo.email '. 'https://www.googleapis.com/auth/userinfo.profile' }
	     );
has auth_uri => (
		 is => 'ro', 
		 isa => 'URI', 
		 required => 1,
		 default => sub { URI->new('https://accounts.google.com/o/oauth2/auth') }
		);

has token_uri => (
		  is => 'ro', 
		  isa => 'URI', 
		  required => 1,
		  default => sub { URI->new('https://accounts.google.com/o/oauth2/token') }
		 );

has api_uri => (
		is => 'ro', 
		isa => 'URI', 
		required => 1,
		default => sub { URI->new('https://www.googleapis.com/oauth2/v2/userinfo') }
	       );

sub BUILDARGS {
    my ($self, $config, $c, $realm) = @_;

    return $config;
}

sub authenticate {
    my ($self, $c, $realm, $auth_info) = @_;

    $c->log->info(dump $auth_info);
    $c->log->info(dump $realm);

    Catalyst::Exception->throw( "Provider is not defined." )
        unless defined $auth_info->{provider} || defined $self->providers->{ $auth_info->{provider} };
    
    my $provider = $self->providers->{ $auth_info->{provider} };
    
    $c->log->debug("######################### bottom ##############################");
    my $auth_uri = $self->auth_uri->clone;
    $auth_uri->query_form(
			  response_type => 'code',
			  client_id     => $provider->{client_id},
			  # this is where it really is
			  redirect_uri  => 'http://hastu.herokuapp.com/google/inst',
			  scope	      => $self->scope
			 );
    
    $c->res->redirect($auth_uri->as_string);
    $c->detach;
}

1;
