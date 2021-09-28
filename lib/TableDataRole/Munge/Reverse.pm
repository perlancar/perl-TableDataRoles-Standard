package TableDataRole::Munge::Reverse;

use 5.010001;
use strict;
use warnings;

use Role::Tiny;

# AUTHORITY
# DATE
# DIST
# VERSION

with 'TableDataRole::Spec::Basic';
with 'TableDataRole::Source::AOA';

sub new {
    require Module::Load::Util;

    my ($class, %args) = @_;

    my $tabledata = delete $args{tabledata} or die "Please specify 'tabledata' argument";
    die "Unknown argument(s): ". join(", ", sort keys %args)
        if keys %args;
    my $td = Module::Load::Util::instantiate_class_with_optional_args(
        {ns_prefix=>"TableData"}, $tabledata);
    my @rows = reverse $td->get_all_rows_arrayref;
    my $column_names = $td->get_column_names;
    TableDataRole::Source::AOA->new(
        aoa => \@rows,
        column_names => $column_names,
    );
}

1;
# ABSTRACT: Reverse the rows of another tabledata

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

To use this role and create a curried constructor:

 package TableDataRole::MyTable;
 use Role::Tiny;
 with 'TableDataRole::Munge::Reverse';
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

This role returns rows from another tabledata module in reverse order.

Implementation notes: this role first loads all the rows into memory, then serve
from it.


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


=head1 SEE ALSO

L<TableData>

=cut
