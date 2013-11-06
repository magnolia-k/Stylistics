package Stylistics::Web::Dispatcher;

use strict;
use warnings;

use utf8;

use Amon2::Web::Dispatcher::RouterBoom;

use Digest::MD5 qw/md5_hex/;

use File::Spec;
use Stylistics::Blog;

my $blog = Stylistics::Blog->new( dir => File::Spec->catdir( 'static', 'blog' ) );

my $email = 'magnolia.k@me.com';
my $size  = 120;
my $site  = "http://www.gravatar.com/avatar/";
my $grav_url = $site . md5_hex(lc $email) . "&s=".$size;

any '/' => sub {
    my ( $c ) = @_;

    return $c->render( 'index.tx' => { image => $grav_url } );
};

any '/blog/' => sub {
	my ( $c ) = @_;

	return $c->render( 'blog.tx' => {
			entries => $blog->list( limit => undef ),
			title   => 'Blog | code-stylistics.net',
			} );
};

any '/archives/' => sub {
	my ( $c ) = @_;

	return $c->render( 'archives.tx' => {
			title   => 'Blog Archives | code-stylistics.net',
			entries => $blog->list( limit => 10 )
			} );
};

any 'archives/{article_index}' => sub {
	my ( $c, $args ) = @_;

	my $entry_id = $args->{article_index};
	$entry_id =~ s/\.html$//;

	my $article = $blog->article( entry_id => $entry_id );

	my $previous = $blog->previous_article( entry_id => $entry_id);
	my $previous_link = $previous ? $previous->filename : undef;

	my $previous_link_html = $previous_link ?
		qq{<li><a href="./$previous_link">Previous</a></li>} :
		undef;

	my $next     = $blog->next_article( entry_id => $entry_id);
	my $next_link = $next ? $next->filename : undef;

	my $next_link_html = $next_link ?
		qq{<li><a href="./$next_link">Next</a></li>} :
		undef;

	return $c->render( 'article.tx' => {
			entry => $article,
			title => $article->title . ' | code-stylistics.net',
			previous_link => $previous_link_html,
			next_link     => $next_link_html,
		   	} );
};

any '/enbld/' => sub {
	my ( $c ) = @_;

	return $c->render( 'enbld.tx' => {
			title => 'Enbld | code-stylistics.net'
			} );
};

# Now disabled about menu.
any '/about/' => sub {
	my ( $c ) = @_;

	return $c->render( 'about.tx' => { image => $grav_url });
};

1;
