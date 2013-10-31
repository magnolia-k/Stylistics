package Stylistics::Blog;

use strict;
use warnings;

use File::Spec;
use autodie;

use JSON qw/decode_json/;

sub new {
    my $class = shift;

    my $self = {
        dir         => undef,
        articles    => {},
        @_,
    };

    bless $self, $class;

    $self->_initialize;

    return $self;
}

sub dir {
	my $self = shift;

	return $self->{dir};
}

sub _initialize {
    my $self = shift;

    my $path = File::Spec->catfile( $self->{dir}, 'index.json' );

    return unless ( -e $path );

    open my $fh, '<', $path;
    my $articles_ref = decode_json( do { local $/; <$fh> } );
    close $fh;

    require Stylistics::Blog::Article;
    for my $article ( @{ $articles_ref } ) {
        my $obj = Stylistics::Blog::Article->new(
				%{ $article },
				blog_ref => $self
				);
        
        $self->{articles}{$obj->basename} = $obj;
    }

    return $self;
}

sub list {
    my $self  = shift;

    my $param = {
        limit => 10,
        @_,
    };

    my @keys = reverse sort {

        $self->{articles}{$a}->date cmp $self->{articles}{$b}->date

    } keys %{ $self->{articles} };

    my @sorted = map { $self->{articles}{$_} } @keys;

	if ( $param->{limit} ) {
		my $limit  = scalar( @sorted ) < $param->{limit} ? scalar( @sorted ) : $param->{limit};
		my @sliced = $param->{limit} ? @sorted[0 .. $limit - 1] : @sorted;
	
		return \@sliced;
	} else {
		return \@sorted;
	}
}

sub article {
    my $self = shift;

    my $param = {
        entry_id => undef,
        @_,
    };

    if ( exists $self->{articles}{$param->{entry_id}} ) {
        return $self->{articles}{$param->{entry_id}};
    }

    return;
}

1;
