#!/usr/bin/env perl

# This script simply prints out the amount of RAM, in GB, or the number of CPU / processor cores, whichever one is smaller.

use strict;
use warnings;

chomp(my $ram = `grep MemTotal /proc/meminfo | awk '{print \$2}'`);     # RAM in KB from /proc/meminfo
$ram = int($ram / 1024000 + 1);                                         # Convert it to GB and add +1 (due to conversion)
chomp(my $cpu = `grep processor /proc/cpuinfo|wc -l`);                  # Number of cores (logical or physical)

my $min = ($ram, $cpu)[$ram > $cpu];                                    # Assign the smaller of the two to $min
print $min;
