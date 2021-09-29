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

our %SPEC;

$SPEC{new} = {
    v => 1.1,
    is_meth => 1,
    is_func => 0,
    args => {
        dsn => {
            schema => 'str*',
        },
        dbh => {
            schema => 'obj*',
        },
        sth => {
            schema => 'obj*',
        },

        # only when using dsn
        user => {
            schema => ['any*', of=>['str*', 'code*']],
        },
        password => {
            schema => ['any*', of=>['str*', 'code*']],
        },

        # only when using dsn or dbh
        query => {
            schema => 'str*',
        },
        table => {
            schema => 'str*',
        },

        # only when using sth
        sth_bind_params => {
            schema => 'array*',
        },

        row_count_sth => {
            schema => 'obj*',
        },
        row_count_query => {
            schema => 'obj*',
        },

        # only when using row_count_sth
        row_count_sth_bind_params => {
            schema => 'array*',
        },
    },
    args_rels => {
        req_one => [qw/dsn dbh sth/],
        choose_one => [qw/query table/],
        'dep_any&' => [
            [user     => [qw/dsn/]],
            [password => [qw/dsn/]],
            [query => [qw/dsn dbh/]],
            [row_count_query => [qw/dsn dbh/]],
            [table => [qw/dsn dbh/]],
            [sth_bind_params => [qw/sth/]],
            [row_count_sth_bind_params => [qw/row_count_sth/]],
        ],
    },
};

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
