use strict;
use warnings;

use Test::More;

use File::Basename;
use File::Spec;

my $dir = File::Spec->catdir( dirname( __FILE__ ), 'test_stuff' );

die "Can't find test stuff:$dir" unless ( -d $dir );

require_ok( 'Stylistics::Blog' );
require_ok( 'Stylistics::Blog::Article' );

my $blog = Stylistics::Blog->new( dir => $dir );

my $newer = $blog->article( entry_id => 'newer_entry' );
my $older = $blog->article( entry_id => 'older_entry' );

like( $newer->text, qr/<p>newer entry string/, 'newer test entry' );
like( $older->text, qr/<p>older entry string/, 'older test entry' );

is( $blog->previous_article( entry_id => 'older_entry' )->entry_id,
		'newer_entry', 'got previous article for older' );
is( $blog->next_article( entry_id => 'older_entry' ), undef,
		'not got next article for older' );

is( $blog->previous_article( entry_id => 'newer_entry' ), undef,
		'not got previous article for newer' );
is( $blog->next_article( entry_id => 'newer_entry' )->entry_id,
	   'older_entry', 'got next article for newer' );

is( @{ $blog->list }, 2, 'blog list' );

my $list = $blog->list( limit => 1 );
is( @{ $list }, 1, 'limited blog list' );

is( $list->[0]->date, '2013-10-31', 'got newer article' );

done_testing();
