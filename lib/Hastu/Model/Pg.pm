package Hastu::Model::Pg;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'Hastu::Data::Pg',
    
    
);

=head1 NAME

Hastu::Model::Pg - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<Hastu>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<Hastu::Data::Pg>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.62

=head1 AUTHOR

Cesano, Simone

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
