package TablesRole::Util::Random;

# AUTHORITY
# DATE
# DIST
# VERSION

# enabled by Role::Tiny
#use strict;
#use warnings;

use Role::Tiny;

requires 'get_row_arrayref';
requires 'get_row_hashref';

sub _get_rand_rows {
    my ($self, $type, $num_items) = @_;
    my @items;
    my $i = -1;
    $self->reset_iterator;
    my $meth = $type eq 'arrayref' ? 'get_row_arrayref' : 'get_row_hashref';
    while (defined(my $item = $self->$meth)) {
        $i++;
        if (@items < $num_items) {
            # we haven't reached $num_items, insert item to array in a random
            # position
            splice @items, rand(@items+1), 0, $item;
        } else {
            # we have reached $num_items, just replace an item randomly, using
            # algorithm from Learning Perl, slightly modified
            rand($i+1) < @items and splice @items, rand(@items), 1, $item;
        }
    }
    \@items;
}

sub get_rand_row_arrayref {
    my $self = shift;
    my $rows = $self->get_rand_rows_arrayref(1);
    $rows ? $rows->[0] : undef;
}

sub get_rand_rows_arrayref {
    my ($self, $n) = @_;
    $self->_get_rand_rows('arrayref', $n);
}

sub get_rand_row_hashref {
    my $self = shift;
    my $rows = $self->get_rand_rows_hashref(1);
    $rows ? $rows->[0] : undef;
}

sub get_rand_rows_hashref {
    my ($self, $n) = @_;
    $self->_get_rand_rows('hashref', $n);
}

1;
# ABSTRACT: Provide utility methods related to getting random rows

=head1 DESCRIPTION

This role provides some utility methods related to getting random rows from the
table. Note that the methods perform a full, one-time, scan of the table using
C<get_row_arrayref> or C<get_row_hashref>. For huge table, this might not be a
good idea. Seekable table can use the more efficient
L<TablesRole::Util::Random::Seekable>.


=head1 PROVIDED METHODS

=head2 get_rand_row_arrayref

Usage:

 my $aryref = $table->get_rand_row_arrayref;

Get a single random row from the table. If table is empty, will return undef.

=head2 get_rand_rows_arrayref

Usage:

 my $aoa = $table->get_rand_rows_arrayref($n);

Get C<$n> random rows from the table. No duplicate rows. If table contains less
than C<$n> rows, only that many rows will be returned.

=head2 get_rand_row_hashref

Usage:

 my $hashref = $table->get_rand_row_hashref;

Get a single random row from the table. If table is empty, will return undef.

=head2 get_rand_rows_hashref

Usage:

 my $aoh = $table->get_rand_rows_hashre($n);

Get C<$n> random rows from the table. No duplicate rows. If table contains less
than C<$n> rows, only that many rows will be returned.


=head1 SEE ALSO

L<TablesRole::Util::Random::Seekable>

Other C<TablesRole::Util::*>

L<Tables>
