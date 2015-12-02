#!./perl
###########################################################################
#
#   caller.t
#
#   Copyright (C) 1999 Raphael Manfredi.
#   Copyright (C) 2002-2015 Mark Rogaski, mrogaski@cpan.org;
#   all rights reserved.
#
#   See the README file included with the
#   distribution for license information.
#
##########################################################################

use Test::More tests => 10;
use Test::File::Contents;
use File::Spec;
use Log::Agent;
require Log::Agent::Driver::File;

my $file_src = __FILE__;
my $file_err = File::Spec->catfile('t', 'file.err');
my $file_out = File::Spec->catfile('t', 'file.out');
unlink $file_err, $file_out;

my $show_error = __LINE__ + 2;
sub show_error {
	logerr "error string";
}

my $show_output = __LINE__ + 2;
sub show_output {
	logsay "output string";
}

my $show_carp = __LINE__ + 2;
sub show_carp {
	logcarp "carp string";
}

my $driver = Log::Agent::Driver::File->make(
	-prefix => 'me',
	-channels => {
		'error' => $file_err,
		'output' => $file_out
	},
);
logconfig(
	-driver => $driver,
	-caller => [ -format => "<%s,%.4d>", -info => "sub line", -postfix => 1 ],
);

show_error;
show_output;
my $carp_line = __LINE__ + 1;
show_carp;

my $error_str = sprintf("%.4d", $show_error);
my $output_str = sprintf("%.4d", $show_output);
my $carp_str = sprintf("%.4d", $show_carp);

file_contents_like $file_err, qr/error string <main::show_error,$error_str>/;
file_contents_unlike $file_err, qr/output string/;
file_contents_like $file_out, qr/output string <main::show_output,$output_str>/;
file_contents_unlike $file_out, qr/error string/;
file_contents_like $file_err,
	qr/carp string at \Q$file_src\E line ${carp_line} <main::show_carp,$carp_str>/;
file_contents_unlike $file_out, qr/carp string/;

unlink $file_err, $file_out;

undef $Log::Agent::Driver;		# Cheat

$driver = Log::Agent::Driver::File->make(
	-prefix => 'me',
	-channels => {
		'error' => $file_err,
		'output' => $file_out
	},
);
logconfig(
	-driver => $driver,
	-caller => [ -format => "<%a>", -info => "pack file sub line" ],
);

show_error;
show_output;

$error_str = $show_error;
$output_str = $show_output;

file_contents_like $file_err,
	qr/<main:\Q$file_src\E:main::show_error:$error_str> error/;
file_contents_like $file_out,
	qr/<main:\Q$file_src\E:main::show_output:$output_str> output/;
unlink $file_err, $file_out;

undef $Log::Agent::Driver;		# Cheat

$driver = Log::Agent::Driver::File->make(
	-prefix => 'me',
	-channels => {
		'error' => 't/file.err',
		'output' => 't/file.out'
	},
);
logconfig(
	-driver => $driver,
	-caller => [ -display => '<$sub/${line}>' ],
);

show_error;
show_output;

file_contents_like $file_err, qr/<main::show_error\/$error_str> error/;
file_contents_like $file_out, qr/<main::show_output\/$output_str> output/;

unlink $file_err, $file_out;
