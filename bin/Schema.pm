package Schema;
use strict;
use base qw/DBIx::Class::Schema/;

__PACKAGE__->load_namespaces();

sub connect {
	my ($self, $db) = @_;
	
	my $dsn = "DBI:mysql:database=$db;host=localhost;port=3306";
	return $self->SUPER::connect(
		$dsn,
		'root', # DB username
		'' # DB password
	);
}

1;