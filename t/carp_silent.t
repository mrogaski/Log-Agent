#!./perl
###########################################################################
#
#   carp_silent.t
#
#   Copyright (C) 1999 Raphael Manfredi.
#   Copyright (C) 2002-2015 Mark Rogaski, mrogaski@cpan.org;
#   all rights reserved.
#
#   See the README file included with the
#   distribution for license information.
#
##########################################################################

use Test::More tests => 2;
use Test::File::Contents;
use File::Spec;
use Log::Agent;
require Log::Agent::Driver::Silent;

open(ORIG_STDOUT, ">&STDOUT") || die "can't dup STDOUT: $!\n";
select(ORIG_STDOUT);

my $file_src = __FILE__;
my $file_err = File::Spec->catfile('t', 'file.err');
my $file_out = File::Spec->catfile('t', 'file.out');
unlink $file_err, $file_out;

open(STDOUT, ">$file_out") || die "can't redirect STDOUT: $!\n";
open(STDERR, ">$file_err") || die "can't redirect STDERR: $!\n";

my $driver = Log::Agent::Driver::Silent->make();
logconfig(-driver => $driver);

sub test {
	logcarp "none";
	logcroak "test";
}

my $line = __LINE__ + 1;
test();

sub END {
	file_contents_unlike $file_err, qr/none/;
	file_contents_like $file_err, qr/test at \Q$file_src\E line $line/;

	unlink $file_err, $file_out;
	exit 0;
}
