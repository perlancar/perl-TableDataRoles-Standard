package ## no critic: Modules::RequireFilenameMatchesPackage
    # hide from PAUSE
    TableDataRole::Test::Source::CSVInFiles;

use 5.010001;
use strict;
use warnings;

use Role::Tiny;
with 'TableDataRole::Source::CSVInFiles';

around new => sub {
    my $orig = shift;

    require File::Basename;
    my @filenames;
    for my $i (1..3) {
        my $filename = File::Basename::dirname(__FILE__) . "/../../../../share/examples/eng-ind$i.csv";
        unless (-f $filename) {
            require File::ShareDir;
            $filename = File::ShareDir::dist_file('TableDataRoles-Standard', "examples/eng-ind$i.csv");
        }
        push @filenames, $filename;
    }
    $orig->(@_, filenames=>\@filenames);
};

package TableData::Test::Source::CSVInFiles;

use 5.010001;
use strict;
use warnings;

use Role::Tiny::With;

# AUTHORITY
# DATE
# DIST
# VERSION

with 'TableDataRole::Test::Source::CSVInFiles';

1;
# ABSTRACT: Some English words with Indonesian equivalents
