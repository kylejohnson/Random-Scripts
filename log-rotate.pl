#!/usr/bin/env perl

# This script will build an array of all files in a directory which have a -YYYYMMDD.log.
# It will not touch today's log
# It will bz2 the last 10 days of logs.
# It will then remove anything older than 10 days (bz2'd or not).
#
# To Do: 
#  * Validate that the @logs and @bz arrays have the correct files in them (regex on YYYYMMDD.log)

use strict;
use warnings;

chomp(my @ten = `for d in \$(seq 1 10); do date --date="\$d days ago" "+%Y%m%d"; done`); # Last 10 days (YYYYMMDD, YYYYMMDD, ...)
my $base = '/opt/whatever';
my $logdir = "$base/logs";
chomp(my $today = `date --date="today" "+%Y%m%d"`);     # Today (YYYYMMDD)
chomp(my @logs = `ls $logdir/*_*.log`); # Array of all .log files
chomp(my @bz = `ls $logdir/*_*.bz2`); # Array of all .bz2 files


foreach (@logs) {
 my $log = $_;
 my $date = substr($log, -12, 8); # YYYYMMDD of log file

 if ($date == $today) { # If today's log
  next; # Skip it
 } elsif (grep $_ eq $date, @ten) { # If log from last 10 days
  compress($log); # Compress it
 } else { # Otherwise, 
  remove($log); # Remove it
 }
}

foreach (@bz) {
 my $log = $_;
 my $date = substr($log, -16, 8); # YYYYMMDD of log file

 unless (grep $_ eq $date, @ten) { # Unless log.bz2 is from within last 10 days
  remove($log); # Remove it
 }
}


sub remove {
 my $log = $_[0];
 #print "Removing $log...\n";
 `rm '$log'`;
}

sub compress {
 my $log = $_[0];
 #print "Compressing $log...\n";
 `bzip2 '$log'`;
}
