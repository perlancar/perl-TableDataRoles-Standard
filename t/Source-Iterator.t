#!perl

use strict;
use warnings;
use Test::Exception;
use Test::More 0.98;

use Tables::Test::Dynamic;

my $t = Tables::Test::Dynamic->new(num_rows=>3);
is($t->as_csv, <<_);
i
1
2
3
_

is($t->get_column_count, 3);
is_deeply([$t->get_column_names], [qw/number en_name id_name/]);
$t->reset_iterator;
is_deeply($t->get_row_arrayref, [qw/1 one satu/]);
is_deeply($t->get_row_hashref , {number=>2, en_name=>"two", id_name=>"dua"});
is_deeply($t->get_row_arrayref, [qw/3 three tiga/]);
$t->reset_iterator;
is_deeply($t->get_row_hashref , {number=>1, en_name=>"one", id_name=>"satu"});
is($t->get_row_count, 5);

done_testing;
