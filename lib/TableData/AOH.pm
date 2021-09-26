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

1;
# ABSTRACT: Get table data from array of hashes

=head1 SYNOPSIS

 use TableData::AOH;

 my $table = TableData::DBI->new(
     aoh => [{col1=>1,col2=>2}, {col1=>3,col2=>4}],
 );


=head1 DESCRIPTION

This is a TableData:: module to get table data from array of hashes.


=head1 SEE ALSO

L<TableData>
