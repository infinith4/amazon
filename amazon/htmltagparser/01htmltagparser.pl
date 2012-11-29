#!/usr/bin/perl

use strict;
use warnings;
use HTML::TagParser;

my $html = HTML::TagParser->new( "index-01.html" );
my $elem = $html->getElementsByTagName( "title" );
print "<title>", $elem->innerText(), "</title>\n" if ref $elem;
