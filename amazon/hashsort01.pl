#!/usr/bin/perl
use strict;
use warnings;

my %points = (Tom => 100, Mike => 30, Mami => 90 ,aaa => 31, dad => 12, dae => 214, fase => 65);

my @sorted_keys = sort { $points{$b} <=> $points{$a} || $a cmp $b }
keys %points;

my @sorturl = ();
my $cnt = 0;

for my $key (@sorted_keys) {
    
    print "%points{$key} = " . $points{$key} . "\n";
    push(@sorturl, $key);
    $cnt++;
    
}

print %points,"\n";


print @sorturl,"\n";



