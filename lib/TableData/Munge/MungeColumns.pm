package TableData::Munge::MungeColumns;

use 5.010001;
use strict;
use warnings;

use Role::Tiny::With;

# AUTHORITY
# DATE
# DIST
# VERSION

with 'TableDataRole::Munge::MungeColumns';

our %SPEC;

$SPEC{new} = {
    v => 1.1,
    is_meth => 1,
    is_func => 0,
    args => {
        tabledata => {
            schema => 'any*', # TMP
            req => 1,
        },
        munge_column_names => {
            schema => ['any*', of=>['str*', 'code*']],
            req => 1,
        },
        munge => {
            schema => ['any*', of=>['str*', 'code*']],
        },
        munge_hashref => {
            schema => ['any*', of=>['str*', 'code*']],
        },
    },
    args_rels => {
        req_one => [qw/munge munge_hashref/],
    },
};

1;
# ABSTRACT: Munge (add, remove, rename, reorder) columns of another tabledata

=head1 SYNOPSIS

 use TableData::Munge::MungeColumns;

 my $td = TableData::Munge::MungeColumns->new(
     tabledata => 'Size::DisplayResolution',
     munge_column_names => sub { my $colnames = shift; push @$colnames, 'area'; $colnames },
     munge_hashref => sub { my $row = shift; $row->{area} = $row->{width} * $row->{height}; $row },
 );


=head1 DESCRIPTION

This is a TableData:: module that lets you munge columns from another tabledata.
See L<TableDataRole::Munge::MungeColumns> for more details.


=head1 SEE ALSO

L<TableData>
