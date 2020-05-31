package WordListRole::EachFromFirstNextReset;

# AUTHORITY
# DATE
# DIST
# VERSION

use Role::Tiny;

requires 'first_word';
requires 'next_word';
requires 'reset_iterator';

sub each_word {
    no warnings 'numeric';

    my ($self, $code) = @_;

    $self->reset_iterator;
    my $word = $self->first_word;
    return undef unless defined $word;
    my $ret = $code->($word);
    return undef if defined $ret && $ret == -2;
    while (1) {
        $word = $self->next_word;
        return undef unless defined $word;
        $ret = $code->($word);
        return undef if defined $ret && $ret == -2;
    }
}

1;
# ABSTRACT: Provide each_word(); relies on first_word(), next_word(), reset_iterator()

=for Pod::Coverage .+

=head1 DESCRIPTION

This role can be used if you want to construct a dynamic wordlist module by
providing providing C<first_word()>, C<next_word()>, C<reset_iterator()>. This
role will add an C<each_word()> method that uses the former three methods.
