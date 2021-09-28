package TableData::AOA;

use 5.010001;
use strict;
use warnings;

use Role::Tiny::With;

# AUTHORITY
# DATE
# DIST
# VERSION

with 'TableDataRole::Source::AOA';

1;
# ABSTRACT: Get table data from array of arrays

=head1 SYNOPSIS

 use TableData::AOA;

 my $table = TableData::AOA->new(
     column_names => [qw/col1 col2/],
     aoa => [ [1,2], [3,4] ],
 );


=head1 DESCRIPTION

This is a TableData:: module to get table data from array of arrays. You also
need to supply column names in C<column_names>.


=head1 SEE ALSO

L<TableData::AOH>

L<TableData>
