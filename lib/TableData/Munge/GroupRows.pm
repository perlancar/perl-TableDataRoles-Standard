package TableData::Munge::GroupRows;

use 5.010001;
use strict;
use warnings;

use Role::Tiny::With;

# AUTHORITY
# DATE
# DIST
# VERSION

with 'TableDataRole::Munge::GroupRows';

our %SPEC;

$SPEC{new} = {
    v => 1.1,
    is_meth => 1,
    is_func => 0,
    args => {
        tabledata => {
            schema => ['any*'], # TMP
            req => 1,
        },
        key => {
            summary => 'Name of key column',
            schema => 'str*',
            default => 'key',
        },
        calc_key => {
            schema => 'code*',
            req => 1,
        },
    },
};

1;
# ABSTRACT: Group rows from another tabledata

=head1 SYNOPSIS

 use TableData::Munge::GroupRows;

 my $td = TableData::Munge::GroupRows->new(
     tabledata => 'Perl::CPAN::Release::Static',
     key => 'date',
     calc_key => sub {
         my $row_hashref = shift;
         my $ymd = $row_hashref->{date} =~ /\A(\d\d\d\d-\d\d-\d\d)/ or die;
         $ymd;
         # TODO: close date gaps
     },
 );


=head1 DESCRIPTION

This is a TableData:: module that lets you group rows from another tabledata
based on a calculated key . See L<TableDataRole::Munge::GroupRows> for more
details.


=head1 SEE ALSO

L<TableData>
