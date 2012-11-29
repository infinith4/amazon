#!/usr/bin/perl

my $str = 'abcdefghijklmnopqrstuvwxyz';
if ($str =~ m/ghi/) {
    print "pre match:$`\n";
    print "post match:$'\n";
}
