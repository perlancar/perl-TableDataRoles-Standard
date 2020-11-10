package TablesRole::Util::CSV;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use Role::Tiny;
requires 'get_column_names';
requires 'get_row_arrayref';
requires 'reset_iterator';

sub as_csv {
    require Text::CSV_XS;
    my $self = shift;

    $self->{csv_parser} //= Text::CSV_XS->new({binary=>1});
    my $csv = $self->{csv_parser};

    $self->reset_iterator;

    my $res = "";
    $csv->combine($self->get_column_names);
    $res .= $csv->string . "\n";
    while (my $row = $self->get_row_arrayref) {
        $csv->combine(@$row);
        $res .= $csv->string . "\n";
    }
    $res;
}

1;
# ABSTRACT: Provide as_csv() and other CSV-related methods

=head1 PROVIDED METHODS

=head2 as_csv

=cut
