package TableData::Test::Source::Iterator;

use 5.010001;
use strict;
use warnings;

use Role::Tiny::With;

# AUTHORITY
# DATE
# DIST
# VERSION

with 'TableDataRole::Source::Iterator';

sub new {
    my ($class, %args) = @_;
    $args{num_rows} //= 10;
    $args{random}   //= 0;

    $class->_new(
        gen_iterator => sub {
            my $i = 0;
            sub {
                $i++;
                return undef if $i > $args{num_rows}; ## no critic: Subroutines::ProhibitExplicitReturnUndef
                return {i=>$args{random} ? int(rand()*$args{num_rows} + 1) : $i};
            };
        },
    );
}

1;
# ABSTRACT: A test table

=head1 SYNOPSIS

 use TableData::Test::Source::Iterator;

 my $table = TableData::Test::Source::Iterator->new(
     # num_rows => 100,   # default is 10
     # random => 1,       # if set to true, will return rows in a random order
 );


=head1 DESCRIPTION

=head2 new

Create object.

Usage:

 my $table = TableData::Test::Source::Iterator->new(%args);

Known arguments:

=over

=item * num_rows

Positive int. Default is 10.

=item * random

Bool. Default is 0.

=back
