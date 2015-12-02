#!./perl
###########################################################################
#
#   Build.PL
#
#   Copyright (C) 2015 Mark Rogaski (mrogaski@cpan.org);
#   all rights reserved.
#
#   See the README file included with the
#   distribution for license information.
#
##########################################################################

use 5.006;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Log::Agent',
    license             => 'artistic_2',
    dist_author         => q{Mark Rogaski <mrogaski@cpan.org>},
    dist_version_from   => 'lib/Log/Agent.pm',
    license             => 'artistic_2',
    release_status      => 'stable',
    configure_requires => {
        'Module::Build' => 0,
    },
    test_requires => {
        'Test::More' => 0,
        'Test::File::Contents' => 0,
    },
    requires => {
        'Tie::Array' => 0,
    },
    add_to_cleanup     => [ 'Log-Agent-*', 't/*.out', 't/*.err' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
