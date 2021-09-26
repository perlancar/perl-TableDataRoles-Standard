package TableDataRole::Source::CSVInDATA;

use 5.010001;
use strict;
use warnings;

use Role::Tiny;

# AUTHORITY
# DATE
# DIST
# VERSION

with 'TableDataRole::Spec::Basic';
with 'TableDataRole::Source::CSVInFile';

around new => sub {
    my $orig = shift;
    my ($class, %args) = @_;
    die "Unknown argument(s): ". join(", ", sort keys %args)
        if keys %args;

    no strict 'refs'; ## no critic: TestingAndDebugging::ProhibitNoStrict
    my $fh = \*{"$class\::DATA"};

    my $obj = $orig->(@_, filehandle => $fh);
};

1;
# ABSTRACT: Role to access table data from CSV in DATA section

=for Pod::Coverage ^(.+)$

=head1 DESCRIPTION

This role expects table data in CSV format in the DATA section. First row MUST
contain the column names.


=head1 ROLES MIXED IN

L<TableDataRole::Spec::Basic>


=head1 PROVIDED METHODS

=head2 as_csv

A more efficient version than one provided by L<TableDataRole::Util::CSV>, since
the data is already in CSV form.


=head1 SEE ALSO

L<TableDataRole::Source::CSVInFile>

=cut
