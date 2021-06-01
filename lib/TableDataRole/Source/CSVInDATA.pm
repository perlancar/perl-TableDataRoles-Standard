package TableDataRole::Source::CSVInDATA;

# AUTHORITY
# DATE
# DIST
# VERSION

use Role::Tiny;
use Role::Tiny::With;
with 'TableDataRole::Spec::Basic';

sub new {
    no strict 'refs';
    require Text::CSV_XS;

    my $class = shift;

    my $fh = \*{"$class\::DATA"};
    my $fhpos_data_begin = tell $fh;

    my $csv_parser = Text::CSV_XS->new({binary=>1});

    my $columns = $csv_parser->getline($fh)
        or die "Can't read columns from first row of CSV";
    my $fhpos_datarow_begin = tell $fh;

    bless {
        fh => $fh,
        fhpos_data_begin => $fhpos_data_begin,
        fhpos_datarow_begin => $fhpos_datarow_begin,
        csv_parser => $csv_parser,
        columns => $columns,
        pos => 0, # iterator
    }, $class;
}

sub as_csv {
    my $self = shift;

    my $fh = $self->{fh};
    my $oldpos = tell $fh;
    seek $fh, $self->{fhpos_data_begin}, 0;
    $self->{index} = 0;
    local $/;
    scalar <$fh>;
}

sub get_column_count {
    my $self = shift;

    scalar @{ $self->{columns} };
}

sub get_column_names {
    my $self = shift;
    wantarray ? @{ $self->{columns} } : $self->{columns};
}

sub has_next_item {
    my $self = shift;
    my $fh = $self->{fh};
    !eof($fh);
}

sub get_next_item {
    my $self = shift;
    my $fh = $self->{fh};
    die "StopIteration" if eof($fh);
    my $row = $self->{csv_parser}->getline($fh);
    $self->{index}++;
    $row;
}

sub get_next_row_hashref {
    my $self = shift;
    my $fh = $self->{fh};
    die "StopIteration" if eof($fh);
    my $row = $self->{csv_parser}->getline($fh);
    $self->{index}++;
    +{ map {($self->{columns}[$_] => $row->[$_])} 0..$#{$self->{columns}} };
}

sub get_iterator_pos {
    my $self = shift;
    $self->{pos};
}

sub reset_iterator {
    my $self = shift;
    my $fh = $self->{fh};
    seek $fh, $self->{fhpos_datarow_begin}, 0;
    $self->{pos} = 0;
}

1;
# ABSTRACT: Role to access table data from CSV in DATA section

=for Pod::Coverage ^(.+)$

=head1 DESCRIPTION

This role expects table data in CSV format in the DATA section. First row MUST
contain the column names.


=head1 ROLES MIXED IN

L<TableDataRole::Spec::Basic>


=head1 PROVIDED METHODS

=head2 as_csv

A more efficient version than one provided by L<TableDataRole::Util::CSV>, since
the data is already in CSV form.


=head1 SEE ALSO

L<TableDataRole::Source::CSVInFile>

=cut
