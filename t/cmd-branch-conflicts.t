#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use App::Git::Workflow::Command::BranchConflicts;
use lib 't/lib';
use Test::Git::Workflow::Command;

our $name = 'test';

run();
done_testing();

sub run {
    my @data = (
        {
            ARGV => [],
            mock => [
                [qw/0.1 0.2/],
            ],
            STD => {
                OUT => "No conflicts.\n",
                ERR => '',
            },
            option => {},
            name   => 'Local brances no conflicts',
        },
        {
            ARGV => [],
            mock => [
                [qw/0.1 0.2/],
            ],
            STD => {
                OUT => '',
                ERR => '',
            },
            option => {},
            name   => 'Local brances conflicts',
        },
        {
            ARGV => [qw/--remote/],
            mock => [
                [qw/0.1 0.2/],
            ],
            STD => {
                OUT => '',
                ERR => '',
            },
            option => {},
            name   => 'Remote brances have no conflicts',
        },
    );

    for my $data (@data) {
        command_ok('App::Git::Workflow::Command::BranchConflicts', $data)
            or return;
    }
}
