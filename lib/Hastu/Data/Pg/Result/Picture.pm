use utf8;
package Hastu::Data::Pg::Result::Picture;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Hastu::Data::Pg::Result::Picture

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<pictures>

=cut

__PACKAGE__->table("pictures");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 caption

  data_type: 'varchar'
  is_nullable: 1
  size: 256

=head2 type

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=head2 base64

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 0 },
  "caption",
  { data_type => "varchar", is_nullable => 1, size => 256 },
  "type",
  { data_type => "varchar", is_nullable => 1, size => 32 },
  "base64",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07040 @ 2014-11-01 10:48:56
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:F9mPE3pHiTO14EOXdD5PHg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
