package ## no critic: Modules::RequireFilenameMatchesPackage
    # hide from PAUSE
    TableDataRole::Test::Source::CSVInFile::Select;

use 5.010001;
use strict;
use warnings;

use Role::Tiny;
with 'TableDataRole::Source::CSVInFile';

around new => sub {
    my $orig = shift;
    my ($class, %args) = @_;

    my $which = delete($args{which}) + 0;

    require File::Basename;
    my $filename = File::Basename::dirname(__FILE__) . "/../../../../../share/examples/eng-ind$which.csv";
    unless (-f $filename) {
        require File::ShareDir;
        $filename = File::ShareDir::dist_file('TableDataRoles-Standard', "examples/eng-ind$which.csv");
    }
    $args{filename} = $filename;
    $orig->($class, %args);
};

package TableData::Test::Source::CSVInFile::Select;

use 5.010001;
use strict;
use warnings;

use Role::Tiny::With;

# AUTHORITY
# DATE
# DIST
# VERSION

with 'TableDataRole::Test::Source::CSVInFile::Select';

1;
# ABSTRACT: Some English words with Indonesian equivalents
