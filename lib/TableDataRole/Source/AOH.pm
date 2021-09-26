package TableDataRole::Source::AOH;

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

    my $aoh = delete $args{aoh} or die "Please specify 'aoh' argument";
    die "Unknown argument(s): ". join(", ", sort keys %args)
        if keys %args;

    bless {
        aoh => $aoh,
        pos => 0,
        # buffer => undef,
        # column_names => undef,
        # column_idxs  => undef,
    }, $class;
}

sub get_column_count {
    my $self = shift;
    my $aoh = $self->{aoh};
    unless (@$aoh) {
        return 0;
    }
    scalar keys(%{ $aoh->[0] });
}

sub get_column_names {
    my $self = shift;
    unless ($self->{column_names}) {
        my $aoh = $self->{aoh};
        $self->{column_names} = [];
        $self->{column_idxs} = {};
        if (@$aoh) {
            my $row = $aoh->[0];
            my $i = -1;
            for (sort keys %$row) {
                push @{ $self->{column_names} }, $_;
                $self->{column_idxs}{$_} = ++$i;
            }
        }
    }
    wantarray ? @{ $self->{column_names} } : $self->{column_names};
}

sub has_next_item {
    my $self = shift;
    $self->{pos} < @{$self->{aoh}};
}

sub get_next_item {
    my $self = shift;
    my $aoh = $self->{aoh};
    die "StopIteration" unless $self->{pos} < @{$aoh};
    my $row_hashref = $aoh->[ $self->{pos}++ ];
    my $row_aryref = [];
    for (keys %$row_hashref) {
        my $idx = $self->{column_idxs}{$_};
        next unless defined $idx;
        $row_aryref->[$idx] = $row_hashref->{$_};
    }
    $row_aryref;
}

sub get_next_row_hashref {
    my $self = shift;
    my $aoh = $self->{aoh};
    die "StopIteration" unless $self->{pos} < @{$aoh};
    $aoh->[ $self->{pos}++ ];
}

sub get_row_count {
    my $self = shift;
    scalar(@{ $self->{aoh} });
}

sub reset_iterator {
    my $self = shift;
    delete $self->{buffer};
    $self->{pos} = 0;
}

sub get_iterator_pos {
    my $self = shift;
    $self->{pos};
}

1;
# ABSTRACT: Get table data from an array of hashes

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

 my $table = TableData::AOH->new(aoh => [{col1=>1,col2=>2}, {col1=>3,col2=>4}]);


=head1 DESCRIPTION

This role retrieves rows from an array of hashrefs.


=head1 ROLES MIXED IN

L<TableDataRole::Spec::Basic>


=head1 SEE ALSO

L<TableData>

=cut
