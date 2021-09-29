package TableData::Munge::Filter;

use 5.010001;
use strict;
use warnings;

use Role::Tiny::With;

# AUTHORITY
# DATE
# DIST
# VERSION

with 'TableDataRole::Munge::Filter';

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
        filter => {
            schema => ['any*', of=>['str*', 'code*']],
        },
        filter_hashref => {
            schema => ['any*', of=>['str*', 'code*']],
        },
    },
    args_rels => {
        req_one => [qw/filter filter_hashref/],
    },
};

1;
# ABSTRACT: Filter rows of another tabledata

=head1 SYNOPSIS

 use TableData::Munge::Filter;

 my $td = TableData::Munge::Filter->new(
     tabledata => 'CPAN::Release::Static::2021',
     filter_hashref => sub { my $row=shift; $_->{author} eq 'PERLANCAR' },
 );


=head1 DESCRIPTION

This is a TableData:: module that lets you filter rows from another tabledata.
See L<TableDataRole::Munge::Filter> for more details.


=head1 SEE ALSO

L<TableData>
