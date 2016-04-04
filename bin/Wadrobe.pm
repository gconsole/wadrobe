package Wadrobe;

use strict;

use Schema;

sub new {
	my ($class) = @_;
	
	my $self = {};
	bless ($self, $class);
	
	return $self;
}

=head1 save

=head2 Description

Save record to C<item> table, if the data with combination of the same name and category
already exist then update, otherwise insert.

=head2 Params

=item $data

Hashref containg values of item name and category, eg -

{ name => 'xxx', category => 'yyy' }

=head2 Returns

void

=cut

sub save {
	my ($self, $data) = @_;
	
	# this is happy case, so skip any type of validation for now
	# save the record onto DB, update if exists
	my $schema = Schema->connect('wadrobe');
	my $record = $schema->resultset('Item')->search({
		name => $data->{name},
		category => $data->{category},
		tag => $data->{tag},
	});
	$record->update_or_create;
	
}

=head1 listItems

=head2 Description

Search item from either C<$keyword> or all from C<item> table and return it as a list.
The search keyword can be partial matched and is case insensitive.

=head2 Returns

Array containing search result in the format of

[
  { name => 'xxx', category => 'yyy' },
  ...
]

=cut

sub listItems {
	my ($self, $keyword) = @_;
	
	my $schema = Schema->connect('wadrobe');
	
	my @items;
	if ($keyword) {
		@items = $schema->resultset('Item')->search({
			'LOWER(name)' => { 'like' => '%'.lc($keyword).'%' }
		});
	}
	else {
		# list all of them
		@items = $schema->resultset('Item')->all;
	}
	my @results = map { { name => $_->get_column('name'), category => $_->get_column('category') } } @items;
	
	return @results;
}

1;