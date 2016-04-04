package Uploader;

use strict;
use File::Type;

=head1 upload

=head2 Description

Upload the file to ./file path.
This is a simple operation and doesn't do any validation or duplication checking ...

=head2 Params

=over

=item $handler

Upload file handler

=item $destination

Destination file name

=back

=head2 Returns

Location of uploaded file

=cut

sub upload {
	my ($class, $handler, $destination) = @_;

	my $file = "file/$destination"; # default to file dir
	open ( UPLOADFILE, ">$file" ) or die "$!";
	binmode UPLOADFILE;
	while ( <$handler> ) {
		print UPLOADFILE;
	}
	close UPLOADFILE;
	
	# validate file or remove it
	my $ft = File::Type->new();
	my $type = $ft->mime_type($file);

	return $file;
}

1;