#!/usr/bin/env perl

use strict;
use warnings;

use Test::More 'tests' => 3;
use Test::Fatal;
use App::Prove;
use App::Prove::Plugin::TestRail;

#I'm the secret squirrel
$ENV{'TESTRAIL_MOCKED'} = 1;

#Test the same sort of data as would come from the Test::Rail::Parser case
my $prove = App::Prove->new();
$prove->process_args(
    "-PTestRail=apiurl=http://some.testlink.install/,user=someUser,password=somePassword,project=TestProject,run=TestingSuite,version=0.014,case_per_ok=1",
    't/fake.test'
);

is( exception { $prove->run() },
    undef, "Running TR parser case via plugin functions" );

#Check that plan, configs and version also make it through
$prove = App::Prove->new();
$prove->process_args(
    "-PTestRail=apiurl=http://some.testlink.install/,user=someUser,password=somePassword,project=TestProject,run=Executing the great plan,version=0.014,case_per_ok=1,plan=GosPlan,configs=testConfig",
    't/fake.test'
);

is( exception { $prove->run() },
    undef,
    "Running TR parser case via plugin functions works with configs/plans" );

#Check that spawn options make it through

$prove = App::Prove->new();
$prove->process_args(
    "-PTestRail=apiurl=http://some.testlink.install/,user=someUser,password=somePassword,project=TestProject,run=TestingSuite2,version=0.014,case_per_ok=1,spawn=9",
    't/skipall.test'
);

is( exception { $prove->run() },
    undef,
    "Running TR parser case via plugin functions works with configs/plans" );
