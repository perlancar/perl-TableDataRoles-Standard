package TableData::DBI;

use 5.010001;
use strict;
use warnings;

use Role::Tiny::With;

# AUTHORITY
# DATE
# DIST
# VERSION

with 'TableDataRole::Source::DBI';

1;
# ABSTRACT: Get table data from DBI

=head1 SYNOPSIS

 use TableData::DBI;

 my $table = TableData::DBI->new(
     sth           => $dbh->prepare("SELECT * FROM mytable"),
     row_count_sth => $dbh->prepare("SELECT COUNT(*) FROM table"),
 );

 # or
 my $table = TableData::DBI->new(
     dsn           => "DBI:mysql:database=mydb",
     user          => "...",
     password      => "...",
     table         => "mytable",
 );


=head1 DESCRIPTION

This is a TableData:: module to table data from a L<DBI> query/table.


=head1 SEE ALSO

L<DBI>

L<TableData>
