#!/usr/bin/perl

use strict;
use warnings;

my $word = "apple:banana:orange";
my @word = split(/:/, $word);

print "@word\n";

print "$word[0]\n";
