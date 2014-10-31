package Yxes::Catalyst::Authentication::Credential::Google;

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

    Catalyst::Exception->throw( "Provider is not defined." )
        unless defined $auth_info->{provider} || defined $self->providers->{ $auth_info->{provider} };
    
    my $provider = $self->providers->{ $auth_info->{provider} };

    $c->log->debug( "authenticate() called from " . $c->request->uri ) if $self->verbose;

    # look for an error from google
    if ($c->req->param('error')) {
	$c->log->debug('authenticate() Google Error Message: ' . $c->req->param('error'));
	$c->stash->{auth_error} = 'Google Responded with: '. $c->req->param('error');
	$c->logout;
	return;
    }
    
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

# doing it this way provides a 'hook' for testing
sub _build_req {
    my ($self, $c, $uri, $attribs, $method)  = @_;
    $method ||= 'GET';

    my $req;
    if ($uri->scheme eq 'file') { # this overrides the method 
       $req = HTTP::Request->new(GET => $uri->as_string);
    } elsif (uc($method) eq 'GET') {
       $req = HTTP::Request->new(GET => $uri->as_string, %$attribs);
    } elsif (uc($method) eq 'POST') {
       $req = POST $uri, [@$attribs];
    } else {
       Catalyst::Exception->throw('URI Error in authenticate(): '.
	"Invalid Method: $method - We can only handle methods GET or POST");
    }
    return $req; # you have to handle errors on your own
}


1; # End of Yxes::Catalyst::Authentication::Credential::Google
