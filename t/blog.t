use strict;
use warnings;

use Test::More;

use File::Basename;
use File::Spec;

my $dir = File::Spec->catdir( dirname( __FILE__ ), 'test_stuff' );

die "Can't find test stuff:$dir" unless ( -d $dir );

require_ok( 'Stylistics::Blog' );
require_ok( 'Stylistics::Blog::Article' );

done_testing();
