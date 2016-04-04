package Display;

use strict;

use Template;
use Schema;
use Wadrobe;
use Exception::Class( 'Display::Exception' );

sub new {
	my ($class) = @_;
	
	my $self = {};
	bless ($self, $class);
	
	return $self;
}

=head1 run

=head2 Description

Run the method as defined by C<$page>

=head2 Params

=item $page

Name of the method to run

=head2 Throws

=item Display::Exception

If the method C<$page> does not exist

=head2 Returns

Void

=cut

sub run {
	my $self = shift;
	my $page = shift;
	
	if ($self->can($page)) {
		no strict 'refs';
		$page->($self);
	}
	else {
		Display::Exception->throw( error => "Cannot display '$page'" );
	}
}

sub index {
	my ($self) = @_;
	
	my $template = Template->read('wadrobe');
	print $template;
	
}

sub listall {
	my ($self) = @_;
	my $schema = Schema->connect('wadrobe');
	
	my @items = Wadrobe->listItems;
	$self->_listItem(\@items);
}

sub search {
	my ($self) = @_;

	my $query = new CGI;
	my $search_keyword = $query->param('search_keyword');

	my @items = Wadrobe->listItems($search_keyword);
	$self->_listItem(\@items);
}


=head1 _listItem

=head2 Description

Take a list of items and display on the page (using table format)

=head2 Params

=item $items

Arrayref containing items to display, name and category are required. eg 

[ { name => 'xxx', category => 'yyy' } ]

=head2 Returns

Void

=cut

sub _listItem {
	my ($self, $items) = @_;
	
	my $output = '<table><tr><td>Name</td><td>Category</td></tr>';
	foreach my $item (@$items) {
		my $name = $item->{name};
		my $category = $item->{category};
		$output .= "<tr><td>$name </td><td> $category </td></tr>";
	}
	$output .= '</table>';
	
	print $output;
}

1;