package Hastu::Authentication::Credential::Google;

use 5.006;
use Moose 2.0602;
use MooseX::Types::Moose 0.27 qw/Bool HashRef/;

use Catalyst::Exception;
use JSON::XS qw/decode_json/;
use Net::OAuth2::Profile::WebServer;
use namespace::autoclean;

use Data::Dump qw/dump/;

our $VERSION = '0.04';

# has verbose => (is => 'ro', isa => Bool, default => 0);

has providers => (is => 'ro', isa => HashRef, required => 1);
has auth => (is => "rw", isa => 'Net::OAuth2::Profile::WebServer');



sub BUILDARGS {
    my ($self, $config, $c, $realm) = @_;
    return $config;
}

sub authenticate {
    my ($self, $c, $realm, $auth_info) = @_;

    if ($c->req->params->{error}) {
	$c->res->body('hey ' . $c->req->params->{error});
	$c->detach;

    }

    unless ($c->req->params->{code}) {
	$self->auth(Net::OAuth2::Profile::WebServer->new(%{$self->providers->{$auth_info->{provider}}}));
	$c->log->info($self->auth->authorize);
	$c->res->redirect($self->auth->authorize);
	$c->detach;
    } else {
	my $user;
	my $provider_id = $auth_info->{provider};
	my $provider = $self->providers->{$provider_id};

	# get the token and put it into the session
	$self->auth(Net::OAuth2::Profile::WebServer->new(%{$provider}));
	my $token = $self->auth->get_access_token($c->req->params->{code});

	$c->session->{tokens}->{$provider_id} = $token->session_freeze;

	# request user data
	my $response = $self->auth->request_auth($token, GET => $provider->{user_uri});
	$user = decode_json($response->content);

	# fix user data
	my %conv = qw/last_name family_name first_name given_name/;
	for (keys %conv) { $user->{$conv{$_}} = $user->{$_} if $user->{$_}; delete $user->{$_} };
	
	# create and update user
	my $u = $c->model($realm->store->config->{user_model})->find_or_create({ id => (join '::', $user->{id}, $auth_info->{provider})});
	for (qw/email family_name given_name/) { $u->$_($user->{$_}) }; $u->username($user->{name}); $u->update;
	$c->set_authenticated($u);
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
