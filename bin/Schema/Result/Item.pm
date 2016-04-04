package Schema::Result::Item;

use base qw/DBIx::Class::Core/;

__PACKAGE__->table('item');
__PACKAGE__->add_columns(qw/ id name category tag /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraints( [ qw/name category/ ] );
  
1;