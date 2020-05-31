package WordListRole::FirstNextResetFromEach;

# AUTHORITY
# DATE
# DIST
# VERSION

use Role::Tiny;

requires 'each_word';

sub first_word {
    my $self = shift;

    $self->reset_iterator;
    $self->next_word;
}

sub next_word {
    my $self = shift;

    unless ($self->{_all_words}) {
        my @wordlist;
        $self->each_word(sub { push @wordlist, $_[0] });
        $self->{_all_words} = \@wordlist;
    }
    $self->{_iterator_idx} = 0 unless defined $self->{_iterator_idx};

    return undef if $self->{_iterator_idx} > $#{ $self->{_all_words} };
    $self->{_all_words}[ $self->{_iterator_idx}++ ];
}

sub reset_iterator {
    my $self = shift;

    $self->{_iterator_idx} = 0;
}

1;
# ABSTRACT: Provide first_word(), next_word(), reset_iterator(); relies on each_word()

=for Pod::Coverage .+

=head1 DESCRIPTION

This role can be used if you want to construct a dynamic wordlist module by
providing C<each_word()>. This role will provide the C<first_word()>,
C<next_word()>, C<reset_iterator()> that uses C<each_word()>.
