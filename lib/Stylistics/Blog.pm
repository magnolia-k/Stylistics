package Stylistics::Blog;

use strict;
use warnings;

use File::Spec;
use autodie;
use JSON qw/decode_json/;
use Encode;

sub new {
    my $class = shift;
    my $dir   = shift;

    my $self = {
        dir         => $dir,
        articles    => {},
        @_,
    };

    bless $self, $class;

    $self->_initialize;

    return $self;
}

sub _initialize {
    my $self = shift;

    my $path = File::Spec->catfile( $self->{dir}, 'index.json' );

    return unless ( -e $path );

    open my $fh, '<', $path;
    my $articles_ref = decode_json( decode( 'UTF-8', do { local $/; <$fh> } ) );
    close $fh;

    require Stylistics::Blog::Article;
    for my $article ( @{ $articles_ref } ) {
        my $obj = Stylistics::Blog::Article->new( %{ $article }, blog => $self );
        
        $self->{articles}{$obj->html_filename} = $obj;
    }

    return $self;
}

sub list {
    my $self  = shift;

    my $param = {
        limit => undef,
        @_,
    };

    my @keys = reverse sort {

        $self->{articles}{$a}->date cmp $self->{articles}{$b}->date

    } keys %{ $self->{articles} };

    my @sorted = map { $self->{articles}{$_} } @keys;

    return @sorted[1..$param->{limit}] if $param->{limit};

    return @sorted;
}

sub article {
    my $self = shift;

    my $param = {
        filename => undef,
        @_,
    };

    if ( exists $self->{articles}{$param->filename} ) {
        return $self->{articles}{$param->filename};
    }

    return;
}

1;
