package TableDataRole::Source::AOA;

use 5.010001;
use strict;
use warnings;

use Role::Tiny;

# AUTHORITY
# DATE
# DIST
# VERSION

with 'TableDataRole::Spec::Basic';

sub new {
    my ($class, %args) = @_;

    my $column_names = delete $args{column_names} or die "Please specify 'column_names' argument";
    my $aoa = delete $args{aoa}     or die "Please specify 'aoa' argument";
    die "Unknown argument(s): ". join(", ", sort keys %args)
        if keys %args;

    bless {
        aoa => $aoa,
        pos => 0,
        column_names => $column_names,
        column_idxs  => {map {$column_names->[$_] => $_} 0..$#{$column_names}},
    }, $class;
}

sub get_column_count {
    my $self = shift;
    scalar @{ $self->{column_names} };
}

sub get_column_names {
    my $self = shift;
    wantarray ? @{ $self->{column_names} } : $self->{column_names};
}

sub has_next_item {
    my $self = shift;
    $self->{pos} < @{$self->{aoa}};
}

sub get_next_item {
    my $self = shift;
    my $aoa = $self->{aoa};
    die "StopIteration" unless $self->{pos} < @{$aoa};
    $aoa->[ $self->{pos}++ ];
}

sub get_next_row_hashref {
    my $self = shift;
    my $aoa = $self->{aoa};
    die "StopIteration" unless $self->{pos} < @{$aoa};
    my $row_aryref = $aoa->[ $self->{pos}++ ];
    +{ map { $self->{column_names}[$_] => $row_aryref->[$_] } 0..$#{$self->{column_names}} };
}

sub get_row_count {
    my $self = shift;
    scalar(@{ $self->{aoa} });
}

sub reset_iterator {
    my $self = shift;
    $self->{pos} = 0;
}

sub get_iterator_pos {
    my $self = shift;
    $self->{pos};
}

1;
# ABSTRACT: Get table data from an array of arrays

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

 my $table = TableData::AOA->new(
     column_names => [qw/col1 col2/],
     aoa => [ [1,2], [3,4] ],
 );


=head1 DESCRIPTION

This role retrieves rows from an array of arrayrefs. You also need to supply
C<column_names> containing array of column names.


=head1 ROLES MIXED IN

L<TableDataRole::Spec::Basic>


=head1 SEE ALSO

L<TableDataRole::Source::AOH>

L<TableData>

=cut
