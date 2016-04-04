package Template;

use strict;
use Exception::Class( 'Template::Exception' );

=head1 read

=head2 Description

Read the template from C<$name>, the actual file is type of .htm and will be concatenate automatically.
The file will be read from template directory in ./template

=head2 Params

=item $name

Name of the template

=head2 Returns

Content of the template

=cut

sub read {
	my ($class, $name) = @_;
	my $filename = 'template/'.$name. '.htm';
	
	unless (-e $filename) {
		Template::Exception->throw( error => "$name template does not exist");
	}
	
	my $data = '';
	if (open(my $fh, '<:encoding(UTF-8)', $filename)) {
		while (my $row = <$fh>) {
			chomp $row;
			$data .= $row;
		}
	}
	return $data;
}

1;