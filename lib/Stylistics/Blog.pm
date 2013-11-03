package Stylistics::Blog;

use strict;
use warnings;

use File::Spec;
use autodie;

use JSON qw/decode_json/;

sub new {
    my $class = shift;

    my $self = {
        dir          => undef,
        articles     => {},
		sorted_index => [],
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

	my @articles;

    require Stylistics::Blog::Article;
    for my $article ( @{ $articles_ref } ) {
        my $ref = Stylistics::Blog::Article->new(
				%{ $article },
				blog_ref => $self
				);
    
		push @articles, $ref;	
    }

	my @sorted = reverse sort { $a->date cmp $b->date } @articles;

	my $previous = undef;
	for my $article ( @sorted ) {
		$self->{articles}{$article->entry_id}{article} = $article;

		if ( $previous ) {
			$self->{articles}{$article->entry_id}{previous} = $previous;

			$self->{articles}{$previous->entry_id}{next} = $article;
		}

		$previous = $article;
	}

	$self->{sorted_index} = \@sorted;

    return $self;
}

sub list {
    my $self  = shift;

    my $param = {
        limit => 10,
        @_,
    };

	if ( $param->{limit} ) {

		my $limit  = scalar( @{ $self->{sorted_index} } ) < $param->{limit} ?
			scalar( @{ $self->{sorted_index} } ) :
			$param->{limit};

		my @sliced = @{ $self->{sorted_index} }[0 .. ( $limit - 1 )];
	
		return \@sliced;

	} else {

		return $self->{sorted_index};

	}
}

sub article {
    my $self = shift;

    my $param = {
        entry_id => undef,
        @_,
    };

    if ( exists $self->{articles}{$param->{entry_id}}{article} ) {
        return $self->{articles}{$param->{entry_id}}{article};
    }

    return;
}

sub previous_article {
	my $self = shift;

	my $param = {
		entry_id => undef,
		@_,
	};

	if ( exists $self->{articles}{$param->{entry_id}}{article} ) {
		return $self->{articles}{$param->{entry_id}}{previous};
	} else {
		return;
	}
}

sub next_article {
	my $self = shift;

	my $param = {
		entry_id => undef,
		@_,
	};

	if ( exists $self->{articles}{$param->{entry_id}}{article} ) {
		return $self->{articles}{$param->{entry_id}}{next};
	} else {
		return;
	}
}

1;
