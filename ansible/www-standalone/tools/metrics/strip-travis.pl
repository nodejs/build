#!/usr/bin/env perl
use strict;
use warnings;
use List::Util qw(any);

my $digcmd = "dig +short nat.travisci.net";
my @travisips = `$digcmd`;
chomp @travisips;

while (<>) {
  my $ipaddr = (split(/,/, $_))[0];
  print if !(any { $_ eq $ipaddr } @travisips);
}
