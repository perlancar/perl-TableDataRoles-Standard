package TableData::AOH;

use 5.010001;
use strict;
use warnings;

use Role::Tiny::With;

# AUTHORITY
# DATE
# DIST
# VERSION

with 'TableDataRole::Source::AOH';

our %SPEC;

$SPEC{new} = {
    v => 1.1,
    is_meth => 1,
    is_func => 0,
    args => {
        aoh => {
            schema => 'aoh*',
            req => 1,
        },
    },
};

1;
# ABSTRACT: Get table data from array of hashes

=head1 SYNOPSIS

 use TableData::AOH;

 my $table = TableData::AOH->new(
     aoh => [{col1=>1,col2=>2}, {col1=>3,col2=>4}],
 );


=head1 DESCRIPTION

This is a TableData:: module to get table data from array of hashes.


=head1 SEE ALSO

L<TableData::AOA>

L<TableData>
