use utf8;
package Hastu::Data::Pg::Result::Pois;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Hastu::Data::Pg::Result::Pois

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<pois>

=cut

__PACKAGE__->table("pois");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 1
  size: 64

=head2 map_id

  data_type: 'integer'
  is_nullable: 1

=head2 lon

  data_type: 'double precision'
  is_nullable: 1

=head2 lat

  data_type: 'double precision'
  is_nullable: 1

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 saved

  data_type: 'integer'
  is_nullable: 1

=head2 extended_data

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 1, size => 64 },
  "map_id",
  { data_type => "integer", is_nullable => 1 },
  "lon",
  { data_type => "double precision", is_nullable => 1 },
  "lat",
  { data_type => "double precision", is_nullable => 1 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "saved",
  { data_type => "integer", is_nullable => 1 },
  "extended_data",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<pois_name>

=over 4

=item * L</name>

=item * L</map_id>

=back

=cut

__PACKAGE__->add_unique_constraint("pois_name", ["name", "map_id"]);


# Created by DBIx::Class::Schema::Loader v0.07040 @ 2014-11-01 10:48:57
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qGCLhc3o33VWBaB5WqwXAw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
