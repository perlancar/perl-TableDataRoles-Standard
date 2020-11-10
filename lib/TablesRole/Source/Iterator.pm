package TablesRole::Source::Iterator;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use Role::Tiny;
use Role::Tiny::With;
with 'TablesRole::Spec::Basic';
with 'TablesRole::Util::CSV';

sub _new {
    my ($class, %args) = @_;

    my $gen_iterator = delete $args{gen_iterator} or die "Please specify 'gen_iterator' argument";
    my $gen_iterator_params = delete $args{gen_iterator_params} // {};

    die "Unknown argument(s): ". join(", ", sort keys %args)
        if keys %args;

    bless {
        gen_iterator => $gen_iterator,
        gen_iterator_params => $gen_iterator_params,
        iterator => undef,
        # buffer => undef,
        # column_names => undef,
        # column_idxs  => undef,
    }, $class;
}

# as_csv from TablesRole::Util::CSV

sub _get_row {
    # get a row from iterator or buffer, and empty the buffer
    my $self = shift;
    if ($self->{buffer}) {
        my $row = delete $self->{buffer};
        if (!ref($row) && $row == -1) {
            return undef;
        } else {
            return $row;
        }
    } else {
        $self->reset_iterator unless $self->{iterator};
        return $self->{iterator}->();
    }
}

sub _peek_row {
    # get a row from iterator, put it in buffer. will return the existing buffer
    # content if it exists.
    my $self = shift;
    unless ($self->{buffer}) {
        $self->reset_iterator unless $self->{iterator};
        $self->{buffer} = $self->{iterator}->() // -1;
    }
    $self->{buffer};
}

sub get_column_count {
    my $self = shift;
    $self->get_column_names;
    scalar(@{ $self->{column_names} });
}

sub get_column_names {
    my $self = shift;
    unless ($self->{column_names}) {
        my $row = $self->_peek_row;
        my $i = -1;
        $self->{column_names} = [];
        $self->{column_idxs} = {};
        for (sort keys %$row) {
            push @{ $self->{column_names} }, $_;
            $self->{column_idxs}{$_} = ++$i;
        }
    }
    wantarray ? @{ $self->{column_names} } : $self->{column_names};
}

sub get_row_arrayref {
    my $self = shift;
    $self->_get_column_names;
    my $row_hashref = $self->_get_row;
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
    $self->reset_iterator;
    unless (defined $self->{row_count}) {
        my $i = 0;
        $i++ while $self->_get_row;
        $self->{row_count} = $i;
    }
    $self->{row_count};
}

sub get_row_hashref {
    my $self = shift;
    $self->_get_row;
}

sub reset_iterator {
    my $self = shift;
    $self->{iterator} = $self->{gen_iterator}->(%{ $self->{gen_iterator_params} });
}

1;
# ABSTRACT: Get table data from an iterator

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

 package Tables::YourTable;
 use Role::Tiny::With;
 with 'TablesRole::Source::Iterator';

 sub new {
     my $class = shift;
     $class->init(
         gen_iterator => sub {
             return sub {
                 ...
             };
         },
     );
 }


=head1 DESCRIPTION


=head1 METHODS

=head2 _new

Create object. This should be called by a consumer's C<new>. Usage:

 my $table = $CLASS->init(%args);

Arguments:

=over

=item * num_rows

Positive int. Default is 10.

=item * random

Bool. Default is 0.

=back


=head1 ROLES MIXED IN

L<TablesRole::Spec::Basic>


=head1 SEE ALSO

L<Tables>

=cut