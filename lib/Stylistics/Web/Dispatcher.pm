package Stylistics::Web::Dispatcher;

use strict;
use warnings;

use utf8;

use Amon2::Web::Dispatcher::RouterBoom;

use Digest::MD5 qw/md5_hex/;

use File::Spec;
use Stylistics::Blog;

my $blog = Stylistics::Blog->new( dir => File::Spec->catdir( 'static', 'blog' ) );

any '/' => sub {
    my ( $c ) = @_;

    return $c->render( 'index.tx' );
};

any '/blog/' => sub {
	my ( $c ) = @_;

	return $c->render( 'blog.tx' => { entries => $blog->list( limit => undef ) } );
};

any '/archives/' => sub {
	my ( $c ) = @_;

	return $c->render( 'archives.tx' => { entries => $blog->list( limit => 10 ) } );
};

any 'archives/{article_index}' => sub {
	my ( $c, $args ) = @_;

	my $entry_id = $args->{article_index};
	$entry_id =~ s/\.html$//;

	my $article = $blog->article( entry_id => $entry_id );

	return $c->render( 'article.tx' => { entry => $article } );
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
