package Stylistics::Web::Dispatcher;

use strict;
use warnings;

use utf8;

use Amon2::Web::Dispatcher::RouterBoom;

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

	return $c->render( 'about.tx' );
};

1;
