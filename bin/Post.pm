package Post;

use strict;

use CGI;
use Uploader;
use Parser;
use Wadrobe;
use Exception::Class( 'Post::Exception' );

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

=item Post::Exception

If the method C<$page> does not exist

=head2 Returns

Void

=cut

sub run {
	my ($self, $page) = @_;
	if ($self->can($page)) {
		no strict 'refs';
		$page->($self);
	}
	else {
		Post::Exception->throw( error => "Cannot post '$page'" );
	}
}

sub wadrobe {
	my ($self) = @_;
	
	# read input
	my $query = new CGI;
	my $filename = $query->param('wadrobe_file');
	
	unless ($filename) {
		# redisplay
		$self->_reDisplay('index', 'No file to update');
	}

	my $file = Uploader->upload( $query->upload("wadrobe_file"), $filename );
	my @data = Parser->parse($file, 1);
	
	unless (scalar(@data)) {
		Post:Exception->throw( error => "Invalid file or it does not contain any data!" );
	}
	
	# save the record
	my $wadrobe = new Wadrobe();
	foreach my $data (@data) {
		$wadrobe->save({
			name => $data->[0],
			category => $data->[1],
			tag => 'outfit', # default tag to outfit for now
		});
	}
	
	# redisplay
	$self->_reDisplay('index', 'Update Success');
}

sub _reDisplay {
	my ($self, $page, $msg) = @_;
	my $display = new Display();
	$display->run($page, $msg);
}

1;