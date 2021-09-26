package ## no critic: Modules::RequireFilenameMatchesPackage
    # hide from PAUSE
    TableDataRole::Test::Source::CSVInFile;

use 5.010001;
use strict;
use warnings;

use Role::Tiny;
with 'TableDataRole::Source::CSVInFile';

around new => sub {
    my $orig = shift;

    require File::Basename;
    my $filename = File::Basename::dirname(__FILE__) . '/../../../../share/examples/eng-ind1.csv';
    unless (-f $filename) {
        require File::ShareDir;
        $filename = File::ShareDir::dist_file('TableDataRoles-Standard', 'examples/eng-ind1.csv');
    }
    $orig->(@_, filename=>$filename);
};

package TableData::Test::Source::CSVInFile;

use 5.010001;
use strict;
use warnings;

use Role::Tiny::With;

# AUTHORITY
# DATE
# DIST
# VERSION

with 'TableDataRole::Test::Source::CSVInFile';

1;
# ABSTRACT: Some English words with Indonesian equivalents
