package TableDataRole::Munge::SerializeRef;

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

    my $tabledata = delete $args{tabledata} or die "Please specify 'tabledata' argument";
    my $load = delete($args{load}) // 1;
    my $serializer = delete($args{serializer}) // 'json';
    die "Unknown argument(s): ". join(", ", sort keys %args)
        if keys %args;

    my $td = Module::Load::Util::instantiate_class_with_optional_args(
        {load=>$load, ns_prefix=>"TableData"}, $tabledata);

    if ($serializer eq 'json') {
        require JSON::MaybeXS;
        $serializer = sub {
            JSON::MaybeXS::encode_json($_[0]);
        };
    } elsif (ref($serializer) ne 'CODE') {
        die "Invalid value for serializer '$serializer': please supply a coderef or 'json'";
    }

    bless {
        tabledata => $tabledata,
        td => $td,
        pos => 0,
        serializer => $serializer,
    }, $class;
}

sub get_column_count {
    my $self = shift;
    $self->{td}->get_column_count;
}

sub get_column_names {
    my $self = shift;
    $self->{td}->get_column_names;
}

sub has_next_item {
    my $self = shift;
    $self->{td}->has_next_item;
}

sub get_next_item {
    my $self = shift;
    my $row = $self->{td}->get_next_item;
    for (@$row) {
        if (ref $_) { $_ = $self->{serializer}->($_) }
    }
    $row;
}

sub get_next_row_hashref {
    my $self = shift;
    my $row = $self->get_next_item;
    unless ($self->{_column_names}) {
        $self->{_column_names} = $self->{td}->get_column_names;
    }
    +{ map {($self->{_column_names}->[$_] => $row->[$_])} 0..$#{$row} };
}

sub get_iterator_pos {
    my $self = shift;
    $self->{td}->get_iterator_pos;
}

sub reset_iterator {
    my $self = shift;
    $self->{td}->reset_iterator;
}

1;
# ABSTRACT: Serialize references in columns

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

To use this role and create a curried constructor:

 package TableDataRole::MyTable;
 use Role::Tiny;
 with 'TableDataRole::Munge::SerializeRef';
 use TableDataRole::MyOtherTable;
 around new => sub {
     my $orig = shift;
     $orig->(@_, tabledata => "MyOtherTable");
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

This role serializes reference values in columns, by default using JSON.


=head1 ROLES MIXED IN

L<TableDataRole::Spec::Basic>


=head1 PROVIDED METHODS

=head2 new

Usage:

 my $obj = $class->new(%args);

Constructor. Known arguments:

=over

=item * tabledata

Required. Name of tabledata module (without the C<TableData::> prefix), with
optional arguments. See
L<Module::Load::Util/instantiate_class_with_optional_args> for more details.

=item * load

Passed to L<Module::Load::Util>'s C<instantiate_class_with_optional_args>.

=item * serializer

A coderef, or one of: C<json>. Default: C<json>.

=back


=head1 SEE ALSO

L<TableData>

=cut
