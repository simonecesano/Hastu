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
}

use JSON::XS qw/decode_json/;

sub authenticate {
    my ($self, $c, $realm, $auth_info) = @_;
    unless ($c->req->params->{code}) {
	$self->auth(Net::OAuth2::Profile::WebServer->new(%{$self->providers->{$auth_info->{provider}}})) unless $self->auth;
	$c->res->redirect($self->auth->authorize);
	$c->detach;
    } else {
	# get the token and put it into the session
	my $token = $self->auth->get_access_token($c->req->params->{code});
	$c->session->{tokens}->{google} = $token->session_freeze;

	# request user data
	my $response = $self->auth->request_auth($token, GET => 'https://www.googleapis.com/oauth2/v2/userinfo');
	my $user = decode_json($response->content);

	# create or update the user
	$c->log->info("auth_info:\n" . dump $auth_info);
	$c->log->info("realm:\n" . dump $realm->store->config->{user_model});
	
	my $u = $c->model($realm->store->config->{user_model})->find_or_create({ id => $user->{id}});
	for (qw/email family_name given_name/) { $u->$_($user->{$_}) }; $u->username($user->{name}); $u->update;
	return 1;
    }
}

1;

__DATA__

    
    local $\ = "\n";
    # print STDERR '#' x 80;
    # print STDERR "build args:\n" . dump $args;
    # print STDERR '#' x 80;

	
	$c->log->info('+' x 80);
	$c->log->info('second round');
	$c->log->info("from: " . $c->req->referer);
	$c->log->info("to:   " . $c->req->uri);
	$c->log->info("store:" . (ref $realm->store));
	$c->log->info("session:\n" . (dump $c->session));
	$c->log->info('+' x 80);


    $c->log->info("auth_info:\n" . dump $auth_info);
    $c->log->info("store:\n" . dump $realm->store);
    $c->log->info("provider:\n" . dump $self->providers->{$auth_info->{provider}});
    $c->log->info("session:\n" . dump $c->session);

	$c->log->info('+' x 80);
	$c->log->info('first round');
	$c->log->info('+' x 80);
