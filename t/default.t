#!./perl
###########################################################################
#
#   default.t
#
#   Copyright (C) 1999 Raphael Manfredi.
#   Copyright (C) 2002-2017 Mark Rogaski, mrogaski@cpan.org;
#   all rights reserved.
#
#   See the README file included with the
#   distribution for license information.
#
##########################################################################

print "1..6\n";

require './t/code.pl';
sub ok;

use Log::Agent;

open(ORIG_STDOUT, ">&STDOUT") || die "can't dup STDOUT: $!\n";
select(ORIG_STDOUT);

open(STDOUT, ">t/default.out") || die "can't redirect STDOUT: $!\n";
open(STDERR, ">t/default.err") || die "can't redirect STDERR: $!\n";

logerr "error";
logsay "message";
loginfo "info";
logdebug "debugging";
logtrc 'debug', "debug";

close STDOUT;
close STDERR;

ok 1, contains("t/default.err", '^Error$');
ok 2, contains("t/default.err", '^Message$');
ok 3, !contains("t/default.err", '^Debug$');
ok 4, !contains("t/default.err", '^Debugging$');
ok 5, !contains("t/default.err", '^Info$');
ok 6, 0 == -s "t/default.out";

unlink 't/default.out', 't/default.err';
