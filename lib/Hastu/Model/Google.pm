package Hastu::Model::Google;
use strict;
use warnings;
use base 'Catalyst::Model::Adaptor';

use Data::Dump qw/dump/;

__PACKAGE__->config( 
    class       => 'Net::OAuth2::Profile::WebServer',
    constructor => 'new',
);

sub prepare_arguments {
    my ($self, $c) = @_; # $app sometimes written as $c
    my %config = %$self;
    for (qw/catalyst_component_name constructor class/) { delete $config{$_} }
    $c->log->info(dump $c->config);
    return \%config;
}

sub mangle_arguments {
    my ($self, $args) = @_;
    return %$args;
}

sub request_auth {
    my $self = shift;
    shift->log->info('foo');
    return $self->SUPER::request_auth(@_);
}

1;
