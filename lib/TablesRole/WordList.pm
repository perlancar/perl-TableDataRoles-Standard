package WordListRole::WordList;

# AUTHORITY
# DATE
# DIST
# VERSION

use Role::Tiny;

requires 'new';
requires 'each_word';
requires 'first_word';
requires 'next_word';
requires 'reset_iterator';
requires 'pick';
requires 'word_exists';
requires 'all_words';

1;
# ABSTRACT: The WordList methods

=head1 REQUIRED METHODS

=head2 new

=head2 each_word

=head2 next_word

=head2 reset_iterator

=head2 pick

Usage:

 @words = $wl->pick([ $num=1 [ , $allow_duplicates=0 ] ]);

Examples:

 ($word) = $wl->pick;    # pick one item, note the list context
 ($word) = $wl->pick(1); # ditto
 @words  = $wl->pick(3);

=head2 word_exists

=head2 all_words
