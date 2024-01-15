package TableDataRole::Util::GetRowByPos;

use 5.010001;
use strict;
use warnings;

use Role::Tiny;

# AUTHORITY
# DATE
# DIST
# VERSION

requires 'reset_iterator';
requires 'has_next_item';
requires 'get_next_item';
requires 'get_next_row_hashref';
with 'TableDataRole::Spec::GetRowByPos';

sub has_item_at_pos {
    my ($self, $index) = @_;
    $self->reset_iterator;
    my $i = 0;
    # XXX implement caching?
    while ($i < $index) {
        die "StopIteration" unless $self->has_next_item;
        $self->get_next_item;
        $i++;
    }
    $self->has_next_item;
}

sub get_item_at_pos {
    my ($self, $index) = @_;
    $self->reset_iterator;
    my $i = 0;
    # XXX implement caching?
    while ($i < $index) {
        die "StopIteration" unless $self->has_next_item;
        $self->get_next_item;
        $i++;
    }
    $self->get_next_item;
}

sub get_row_at_pos_hashref {
    my ($self, $index) = @_;
    $self->reset_iterator;
    my $i = 0;
    # XXX implement caching?
    while ($i < $index) {
        die "StopIteration" unless $self->has_next_item;
        $self->get_next_item;
        $i++;
    }
    $self->get_next_row_hashref;
}

1;
# ABSTRACT: Provide TableDataRole::Spec::GetRowByPos methods using iteration

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

 use Role::Tiny ();

 # instantiate a TableData module that does not support TableDataRole::Spec::GetRowByPos
 my $table = TableData::Foo->new(...);

 # add support for TableDataRole::Spec::GetRowByPos
 Role::Tiny->apply_roles_to_object($table, "TableDataRole::Util::GetRowByPos");


=head1 DESCRIPTION

This role provides methods specified by L<TableDataRole::Spec::GetRowByPos>. The
implementation is iteration using the basic TableData interface. It can make any
TableData module support the GetRowByPos interface, but very inefficiently.


=head1 ROLES MIXED IN

L<TableDataRole::Spec::GetRowByPos>


=head1 SEE ALSO

L<TableData>

=cut
