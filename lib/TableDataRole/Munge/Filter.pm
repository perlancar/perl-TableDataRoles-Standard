package TableDataRole::Munge::Filter;

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
    require Module::Load::Util;

    my ($class, %args) = @_;

    my $tabledata = delete $args{tabledata}
        or die "Please supply 'tabledata' argument";
    my $filter = delete $args{filter};
    my $filter_hashref = delete $args{filter_hashref};
    ($filter || $filter_hashref) or die "Please supply 'filter' or 'filter_hashref' argument";
    die "Unknown argument(s): ". join(", ", sort keys %args)
        if keys %args;

    $tabledata = Module::Load::Util::instantiate_class_with_optional_args({ns_prefix=>"TableData"}, $tabledata);
    my $column_names = $tabledata->get_column_names;

    bless {
        tabledata => $tabledata,
        column_names => $column_names,
        column_idxs => {map {$column_names->[$_] => $_} 0..$#{$column_names}},
        filter => $filter,
        filter_hashref => $filter_hashref,
        pos => 0, # iterator
        # buffer => undef,
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

sub _fill_buffer {
    my $self = shift;
    return if $self->{buffer};
    while (1) {
        return unless $self->{tabledata}->has_next_item;
        if ($self->{filter}) {
            my $row = $self->{tabledata}->get_next_row_arrayref;
            if ($self->{filter}->($row)) {
                $self->{buffer} = $row;
                return;
            }
        } else {
            my $row = $self->{tabledata}->get_next_item;
            my $row_hashref = { map {$self->{column_names}[$_] => $row->[$_]} 0..$#{$row} };
            if ($self->{filter_hashref}->($row_hashref)) {
                $self->{buffer} = $row;
                return;
            }
        }
    }
}

sub has_next_item {
    my $self = shift;
    return 1 if $self->{buffer};
    $self->_fill_buffer;
    return $self->{buffer} ? 1:0;
}

sub get_next_item {
    my $self = shift;
    $self->_fill_buffer;
    die "StopIteration" unless $self->{buffer};
    $self->{pos}++;
    return delete $self->{buffer};
}

sub get_next_row_hashref {
    my $self = shift;
    my $row = $self->get_next_item;
    +{ map {($self->{column_names}->[$_] => $row->[$_])} 0..$#{$row} };
}

sub get_iterator_pos {
    my $self = shift;
    $self->{pos};
}

sub reset_iterator {
    my $self = shift;
    $self->{tabledata}->reset_iterator;
    $self->{pos} = 0;
}

1;
# ABSTRACT: Role to filter rows from another tabledata

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

To use this role and create a curried constructor:

 package TableDataRole::MyTable;
 use Role::Tiny;
 with 'TableDataRole::Munge::Filter';
 around new => sub {
     my $orig = shift;
     $orig->(@_,
         tabledata => 'CPAN::Release::Static::2021',
         filter_hashref => sub { my $row = shift; $row->{author} eq 'PERLANCAR' },
     );
 };

 package TableData::MyTable;
 use Role::Tiny::With;
 with 'TableDataRole::MyTable';
 1;

In code that uses your TableData class:

 use TableData::MyTable;

 my $td = TableData::MyTable->new;
 ...


=head1 DESCRIPTION


=head1 ROLES MIXED IN

L<TableDataRole::Spec::Basic>


=head1 PROVIDED METHODS

=head2 new

Usage:

 my $obj = $class->new(%args);

Constructor. Known arguments:

=over

=item * tabledata

Required. Tabledata module name (without the C<TableData::> prefix) with
optional arguments (see L<Module::Load::Util> for more details).

=item * filter

A coderef to filter the rows. Will be passed an arrayref which is the row to
filter. Must return true if the row should be included, or false if otherwise.

Either C<filter> B<or> C<filter_hashref> must be specified.

=item * filter_hashref

A coderef to filter the rows. Will be passed a B<hashref> which is the row to
filter. Must return true if the row should be included, or false if otherwise.

Either C<filter> B<or> C<filter_hashref> must be specified.

=back

Note that if your class wants to wrap this constructor in its own, you need to
create another role first, as shown in the example in Synopsis.


=head1 SEE ALSO

=cut
