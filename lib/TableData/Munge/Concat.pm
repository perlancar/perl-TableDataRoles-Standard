package TableData::Munge::Concat;

use 5.010001;
use strict;
use warnings;

use Role::Tiny::With;

# AUTHORITY
# DATE
# DIST
# VERSION

with 'TableDataRole::Munge::Concat';

our %SPEC;

$SPEC{new} = {
    v => 1.1,
    is_meth => 1,
    is_func => 0,
    args => {
        tabledatalist => {
            schema => ['array*', min_len=>1], # TMP
            req => 1,
        },
    },
};

1;
# ABSTRACT: Access a series of other tabledata instances

=head1 SYNOPSIS

 use TableData::Munge::Concat;

 my $td = TableData::Munge::Concat->new(
     tabledatalist => [
         'CPAN::Release::Static::2020',
         'CPAN::Release::Static::2021',
     ],
 );


=head1 DESCRIPTION

This is a TableData:: module that lets you access a series of other tabledata
instances. See L<TableDataRole::Munge::Concat> for more details.


=head1 SEE ALSO

L<TableData>
