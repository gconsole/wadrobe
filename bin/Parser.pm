package Parser;

use strict;
use Parse::CSV;

=head1 parse

=head2 Description

Parse the data from C<$file> using CSV parser.

=head2 Params

=over

=item $file

File location to parse from.

=item $skip_header

Skip reading header row if true, otherwise include it.

=back

=head2 Returns

Array containg each row of the data from the file.

=cut

sub parse {
	my ($class, $file, $skip_header) = @_;
	
	my $input = Parse::CSV->new(
		file => $file,
	);
	
	my @data;
	while ( my $data = $input->fetch ) {
		push @data, $data;
	}
	
	shift @data if $skip_header;
	
	return @data;
}

1;