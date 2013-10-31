package Stylistics::Blog::Article;

use strict;
use warnings;

use Text::Markdown qw/markdown/;

sub new {
    my $class = shift;

    my $self = {
        title    => undef,
        date     => undef,
        entry_id => undef,
        text     => undef,
        blog_ref => undef,
        @_,
    };

    bless $self, $class;

    return $self;
}

sub title {
	my $self = shift;

	return $self->{title};
}

sub date {
    my $self = shift;

    return $self->{date};
}

sub basename {
	my $self = shift;

	return $self->{entry_id};
}

sub entry_id {
	my $self = shift;

	return $self->{entry_id};
}

sub filename {
    my $self = shift;

    return $self->basename . '.html';
}

sub source {
    my $self = shift;

    return $self->basename . '.md';
}

sub text {
    my $self = shift;

    return $self->{text} if $self->{text};

    my $path = File::Spec->catfile( $self->{blog_ref}->dir, $self->source );

	unless ( -e $path ) {
        die "article file is not exists:$path";
    }

    open my $fh, '<', $path;
    my $text = do { local $/; <$fh> };
    close $fh;

    return ( $self->{text} = markdown( $text ) );
}

1;
