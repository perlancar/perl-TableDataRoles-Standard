package TablesRole::Util::Basic;

# AUTHORITY
# DATE
# DIST
# VERSION

use strict;
use warnings;
use Role::Tiny;

requires 'get_row_arrayref';
requires 'get_row_hashref';

sub as_aoa {
    my $self = shift;
    $self->reset_iterator;
    my @aoa;
    while (my $row = $self->get_row_arrayref) {
        push @aoa, $row;
    }
    \@aoa;
}

sub as_aoh {
    my $self = shift;
    $self->reset_iterator;
    my @aoh;
    while (my $row = $self->get_row_hashref) {
        push @aoh, $row;
    }
    \@aoh;
}

1;
# ABSTRACT: Provide utility methods

=head1 DESCRIPTION

This role provides some basic utility methods.


=head1 PROVIDED METHODS

=head2 as_aoa

Usage:

 my $aoa = $table->as_aoa;

Return table data as array of arrayrefs. Will reset row iterator.

=head2 as_aoh

Usage:

 my $aoh = $table->as_aoh;

Return table data as array of hashrefs. Will reset row iterator.


=head1 SEE ALSO

Other C<TablesRole::Util::*>

L<Tables>
