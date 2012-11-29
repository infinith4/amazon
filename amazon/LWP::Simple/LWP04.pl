#!/usr/bin/perl

use LWP::Simple;
print "Content-type: text/html; \n\n";

getstore("http://www.yahoo.co.jp/", "test.txt");
