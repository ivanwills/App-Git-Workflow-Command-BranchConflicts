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
                { branch   => [map {" $_"} qw/master other/] },
                { checkout => undef },
                { merge    => undef },
                { status   => '# modified file1' },
                { merge    => undef },
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
                { branch   => [map {" $_"} qw/master branch1 branch2 branch3 branch4/] },
                { checkout => undef },
                # branch1 -> branch2
                { merge => undef }, { status => '# both modified: file1' }, { merge => undef },
                # branch1 -> branch3
                { merge => undef }, { status => '# modified file1' }, { merge => undef },
                # branch1 -> branch4
                { merge => undef }, { status => '# modified file1' }, { merge => undef },
                # branch1 -> master
                { merge => undef }, { status => '# modified file1' }, { merge => undef },
                { checkout => undef },
                # branch2 -> branch3
                { merge => undef }, { status => '# modified file1' }, { merge => undef },
                # branch2 -> branch4
                { merge => undef }, { status => '# modified file1' }, { merge => undef },
                # branch2 -> master
                { merge => undef }, { status => '# modified file1' }, { merge => undef },
                { checkout => undef },
                # branch3 -> branch4
                { merge => undef }, { status => '# both modified: file1' }, { merge => undef },
                # branch3 -> master
                { merge => undef }, { status => '# modified file1' }, { merge => undef },
                { checkout => undef },
                # branch4 -> master
                { merge => undef }, { status => '# modified file1' }, { merge => undef },
            ],
            STD => {
                OUT => <<'OUT',
Conflicting branches:
    branch1 branch2
    branch3 branch4
OUT
                ERR => '',
            },
            option => {},
            name   => 'Local brances conflicts',
        },
        {
            ARGV => [qw/--remote/],
            mock => [
                { branch   => [map {" $_"} qw{origin/master origin/other}] },
                { checkout => undef },
                { merge    => undef },
                { status   => '# modified file1' },
                { merge    => undef },
            ],
            STD => {
                OUT => "No conflicts.\n",
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
