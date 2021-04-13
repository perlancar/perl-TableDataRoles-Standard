package TableDataRole::Source::AOH;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use Role::Tiny;
use Role::Tiny::With;
with 'TableDataRole::Spec::Basic';

sub new {
    my ($class, %args) = @_;

    my $aoh = delete $args{aoh} or die "Please specify 'aoh' argument";
    die "Unknown argument(s): ". join(", ", sort keys %args)
        if keys %args;

    bless {
        aoh => $aoh,
        index => 0,
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

sub get_row_hashref {
    my $self = shift;
    my $aoh = $self->{aoh};
    return undef unless $self->{index} < @{$aoh};
    $aoh->[ $self->{index}++ ];
}

sub get_row_arrayref {
    my $self = shift;
    my $aoh = $self->{aoh};
    return undef unless $self->{index} < @{$aoh};
    my $row_hashref = $aoh->[ $self->{index}++ ];
    my $row_aryref = [];
    for (keys %$row_hashref) {
        my $idx = $self->{column_idxs}{$_};
        next unless defined $idx;
        $row_aryref->[$idx] = $row_hashref->{$_};
    }
    $row_aryref;
}

sub get_row_count {
    my $self = shift;
    scalar(@{ $self->{aoh} });
}

sub reset_row_iterator {
    my $self = shift;
    $self->{index} = 0;
}

sub get_row_iterator_index {
    my $self = shift;
    $self->{index};
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
