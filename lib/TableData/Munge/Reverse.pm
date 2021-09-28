package TableData::Munge::Reverse;

use 5.010001;
use strict;
use warnings;

use Role::Tiny::With;

# AUTHORITY
# DATE
# DIST
# VERSION

with 'TableDataRole::Munge::Reverse';

1;
# ABSTRACT: Reverse the order of rows of another tabledata

=head1 SYNOPSIS

 use TableData::Munge::Reverse;

 my $td = TableData::Munge::Reverse->new(
     tabledata => 'CPAN::Release::Static::2021',
 );


=head1 DESCRIPTION

This is a TableData:: module that reverses the order of rows of another
tabledata. See L<TableDataRole::Munge::Reverse> for more details.


=head1 SEE ALSO

L<TableData>
