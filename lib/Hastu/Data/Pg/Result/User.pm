use utf8;
package Hastu::Data::Pg::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Hastu::Data::Pg::Result::User

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<users>

=cut

__PACKAGE__->table("users");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 0

=head2 username

  data_type: 'text'
  is_nullable: 1

=head2 password

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns
    (
     'id'
     => {
	 'is_auto_increment' => 0,
	 'size' => '0',
	 'is_nullable' => 0,
	 'data_type' => 'varchar',
	 'size' => '128',
	 'name' => 'id',
	 'is_foreign_key' => 0,
	 'default_value' => undef
	},
     'username' 
     => {
	 'data_type' => 'varchar',
	 'name' => 'username',
	 'size' => '128',
	 'is_auto_increment' => 0,
	 'is_nullable' => 1,
	 'default_value' => undef,
	 'is_foreign_key' => 0
	 },
     'given_name' 
     => {
	 'is_nullable' => 1,
	 'is_auto_increment' => 0,
	 'size' => '128',
	 'name' => 'given_name',
	 'data_type' => 'varchar',
	 'default_value' => undef,
	 'is_foreign_key' => 0
	 },
     'family_name' 
     => {
	 'default_value' => undef,
	 'is_foreign_key' => 0,
	 'is_nullable' => 1,
	 'size' => '128',
	 'is_auto_increment' => 0,
	 'name' => 'family_name',
	 'data_type' => 'varchar'
	 },
     'email' 
     => {
	 'default_value' => undef,
	 'is_foreign_key' => 0,
	 'is_auto_increment' => 0,
	 'size' => '128',
	 'is_nullable' => 1,
	 'data_type' => 'varchar',
	 'name' => 'email'
	 },
     'password' 
     => {
	 'is_foreign_key' => 0,
	 'default_value' => undef,
	 'data_type' => 'varchar',
	 'name' => 'password',
	 'size' => '128',
	 'is_auto_increment' => 0,
	 'is_nullable' => 1
	 },
     );

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 user_roles

Type: has_many

Related object: L<Hastu::Data::Pg::Result::UserRole>

=cut

__PACKAGE__->has_many(
  "user_roles",
  "Hastu::Data::Pg::Result::UserRole",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 roles

Type: many_to_many

Composing rels: L</user_roles> -> role

=cut

__PACKAGE__->many_to_many("roles", "user_roles", "role");


# Created by DBIx::Class::Schema::Loader v0.07040 @ 2014-11-01 10:48:58
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2+mSJeYW18J1PCctVSzMCg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
