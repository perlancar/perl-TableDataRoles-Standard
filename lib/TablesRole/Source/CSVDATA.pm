package TablesRole::Source::CSVDATA;

# AUTHORITY
# DATE
# DIST
# VERSION

use Role::Tiny::With;
with 'TablesRole::Spec::Basic';

sub new {
    require Text::CSV_XS;

    my $class = shift;

    my $fh = \*{"$class\::DATA"};
    my $fhpos_data_begin = tell $fh;

    my $parser = Text::CSV_XS->new({binary=>1});

    my $columns = $csv->getline($fh)
        or die "Can't read columns from first row of CSV";
    my $fhpos_datarow_begin = tell $fh;

    bless {
        fh => $fh,
        fhpos_data_begin => $fhpos_data_begin,
        fhpos_datarow_begin => $fhpos_datarow_begin,
        parser => $parser,
        columns => $columns,
        i => 0, # iterator
    }, $class;
}

sub as_csv {
    my $self = shift;

    my $fh = $self->{fh};
    my $oldpos = tell $fh;
    seek $fh, $self->{fhpos_data_begin}, 0;
    $self->{i} = -1;
    local $/;
    scalar <$fh>;
}

sub get_column_count {
    my $self = shift;

    scalar @{ $self->{columns} };
}

sub get_column_names {
    my $self = shift;
    @{ $self->{columns} };
}

sub get_row_arrayref {
    my $self = shift;
    my $row = $self->{parser}->getline;
    return unless $row;
    $self->{i}++;
    $row;
}

sub get_row_count {
    my $self = shift;

    1 while my $row = $self->get_row_arrayref;
    $self->{i};
}

sub get_row_hashref {
    my $self = shift;
    my $row_arrayref = $self->get_row_arrayref;
    return unless $row_arrayref;

    # convert to hashref
    my $row_hashref = {};
    my $columns = $self->{columns};
    for my $i (0 .. $#{$columns}) {
        $row_hashref->{ $columns->[$i] } = $row_arrayref->[$i];
    }
    $row_hashref;
}

sub reset_indicator {
    my $self = shift;
    my $fh = $self->{fh};
    seek $fh, $self->{fhpos_datarow_begin}, 0;
    $self->{i} = 0;
}

1;
# ABSTRACT: Role to access table data from CSV in DATA section

=for Pod::Coverage ^(.+)$

=head1 DESCRIPTION

This role expects table data in CSV format in the DATA section. First row MUST
contain the column names.


=head1 ROLES MIXED IN

L<TablesRole::Spec::Basic>


=head1 SEE ALSO

L<TablesRole::Source::CSVFile>

=cut
