#!/usr/bin/perl
use lib 'bin';
use strict;

use CGI;
use Display;
use Post;
use Try::Tiny;
use Data::Dumper;

print "Content-type: text/html\n\n";

my $q = CGI->new;
my $func = $q->param('func');

try {
	# func is either 'post' or 'get'
	# get is default if not defined
	my $obj;
	my $page = $q->param('page');
	if ($func eq 'post') {
		$obj = new Post();
	}
	else {
		$obj = new Display();
		# for simplicity, make index as default page if not defined
		$page = 'index' unless $page;
	}
	$obj->run( $page );
}
catch {
	my $error = shift;
	if (
		UNIVERSAL::isa($error, 'Display::Exception') ||
		UNIVERSAL::isa($error, 'Post::Exception') ||
		UNIVERSAL::isa($error, 'Template::Exception')
	) {
		print $error->error;
	}
	else {
		# only for debugging, not safe to print out to the world
		print Data::Dumper::Dumper($error);
	}
};
