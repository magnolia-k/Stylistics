package Stylistics::Web::Dispatcher;

use strict;
use warnings;

use utf8;

use Amon2::Web::Dispatcher::RouterBoom;

use Digest::MD5 qw/md5_hex/;

any '/' => sub {
    my ( $c ) = @_;

    return $c->render( 'index.tx' );
};

any '/blog/' => sub {
	my ( $c ) = @_;

	my @entries = ( 'aaa', 'bbb' );

	return $c->render( 'blog.tx' => { entries => \@entries } );
};

any '/archives/' => sub {
	my ( $c ) = @_;

	return $c->render( 'archives.tx' );
};

any '/enbld/' => sub {
	my ( $c ) = @_;

	return $c->render( 'enbld.tx' );
};

any '/about/' => sub {
	my ( $c ) = @_;

	my $email = 'magnolia.k@me.com';
	my $size  = 120;
	my $site  = "http://www.gravatar.com/avatar/";
	my $grav_url = $site . md5_hex(lc $email) . "&s=".$size;

	return $c->render( 'about.tx' => { image => $grav_url });
};

1;
