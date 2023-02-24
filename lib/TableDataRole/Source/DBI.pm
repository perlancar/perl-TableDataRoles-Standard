package TableDataRole::Source::DBI;

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

    my $dsn      = delete $args{dsn};
    my $user     = delete $args{user};
    my $password = delete $args{password};
    my $dbh = delete $args{dbh};
    if (defined $dbh) {
    } elsif (defined $dsn) {
        require DBI;
        $dbh = DBI->connect($dsn, $user, $password, {RaiseError=>1});
    }

    my $sth   = delete $args{sth};
    my $sth_bind_params = delete $args{sth_bind_params};
    my $query = delete $args{query};
    my $table = delete $args{table};
    if (defined $sth) {
    } else {
        die "You specify 'query' or 'table', but you don't specify ".
            "dbh/dsn+user+password, so I cannot create a statement handle"
            unless $dbh;
        if (defined $query) {
        } elsif (defined $table) {
            $query = "SELECT * FROM $table";
        } else {
            die "Please specify 'sth', 'query', or 'table' argument";
        }
        $sth = $dbh->prepare($query);
        $sth->execute(@{ $sth_bind_params // [] }); # to check query syntax
    }

    my $row_count_sth = delete $args{row_count_sth};
    my $row_count_sth_bind_params = delete $args{row_count_sth_bind_params};
    my $row_count_query = delete $args{row_count_query};
    if (defined $row_count_sth) {
    } else {
        die "You specify 'row_count_query' or 'table', but you don't specify ".
            "dbh/dsn+user+password, so I cannot create a statement handle"
            unless $dbh;
        if (defined $row_count_query) {
        } elsif (defined $table) {
            $row_count_query = "SELECT COUNT(*) FROM $table";
        } else {
            die "For getting row count, please specify 'row_count_sth', ".
                "'row_count_query', or 'table' argument";
        }
        $row_count_sth = $dbh->prepare($row_count_query);
        $sth->execute(@{ $row_count_sth_bind_params // [] }); # to check query syntax
    }

    die "Unknown argument(s): ". join(", ", sort keys %args)
        if keys %args;

    bless {
        #dbh => $dbh,
        sth => $sth,
        sth_bind_params => $sth_bind_params,
        row_count_sth => $row_count_sth,
        row_count_sth_bind_params => $row_count_sth_bind_params,

        pos => 0,
    }, $class;
}

sub _get_row {
    # get a hashref row from sth, and empty the buffer
    my $self = shift;
    if ($self->{buffer}) {
        my $row = delete $self->{buffer};
        if (!ref($row) && $row == -1) {
            return undef; ## no critic: Subroutines::ProhibitExplicitReturnUndef
        } else {
            return $row;
        }
    } else {
        my $row = $self->{sth}->fetchrow_hashref;
        return undef unless $row; ## no critic: Subroutines::ProhibitExplicitReturnUndef
        return $row;
    }
}

sub _peek_row {
    # get a row from iterator, put it in buffer. will return the existing buffer
    # content if it exists.
    my $self = shift;
    unless ($self->{buffer}) {
        $self->{buffer} = $self->{sth}->fetchrow_hashref // -1;
    }
    if (!ref($self->{buffer}) && $self->{buffer} == -1) {
        return undef; ## no critic: Subroutines::ProhibitExplicitReturnUndef
    } else {
        return $self->{buffer};
    }
}

sub get_column_count {
    my $self = shift;
    $self->{sth}{NUM_OF_FIELDS};
}

sub get_column_names {
    my $self = shift;
    wantarray ? @{ $self->{sth}{NAME_lc} } : $self->{sth}{NAME_lc};
}

sub has_next_item {
    my $self = shift;
    $self->_peek_row ? 1:0;
}

sub get_next_item {
    my $self = shift;
    my $row_hashref = $self->_get_row;
    die "StopIteration" unless $row_hashref;
    $self->{pos}++;
    my $row_aryref = [];
    my $column_names = $self->get_column_names;
    for (0..$#{$column_names}) {
        $row_aryref->[$_] = $row_hashref->{ $column_names->[$_] };
    }
    $row_aryref;
}

sub get_next_row_hashref {
    my $self = shift;
    my $row = $self->_get_row;
    die "StopIteration" unless $row;
    $self->{pos}++;
    $row;
}

sub get_row_count {
    my $self = shift;
    $self->{row_count_sth}->execute(@{ $self->{row_count_sth_bind_params} // [] });
    my ($row_count) = $self->{row_count_sth}->fetchrow_array;
    $row_count;
}

sub reset_iterator {
    my $self = shift;
    $self->{sth}->execute(@{ $self->{sth_bind_params} // [] });
    delete $self->{buffer};
    $self->{pos} = 0;
}

sub get_iterator_pos {
    my $self = shift;
    $self->{pos};
}

1;
# ABSTRACT: Role to access table data from DBI

=for Pod::Coverage ^(.+)$

=head1 DESCRIPTION

This role expects table data in L<DBI> database table.


=head1 METHODS

=head2 new

Usage:

 my $table = $CLASS->new(%args);

Arguments:

=over

=item * sth

=item * dbh

=item * query

=item * table

One of L</sth>, L</dbh>, L</query>, or L</table> is required.

=item * row_count_sth

=item * row_count_query

One of L</row_count_sth>, L</row_count_query>, or L</table> is required. If you
specify C<row_count_query> or C<table>, you need to specify L</dbh> or L</dsn>.

=back


=head1 ROLES MIXED IN

L<TableDataRole::Spec::Basic>


=head1 SEE ALSO

L<TableDataRole::Source::SQLite>

L<DBI>

L<TableData>

=cut
