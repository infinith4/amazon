#!/usr/bin/perl
use strict;
use warnings;
use Digest::SHA qw(hmac_sha256_base64);
use URI::Escape;

my $data = q(GET
webservices.amazon.com
/onca/xml
AWSAccessKeyId=AKIAIO4F32K7CCUII6KA&ItemId=0679722769&Operation=I\
temLookup&ResponseGroup=ItemAttributes%2COffers%2CImages%2CReview\
s&Service=AWSECommerceService&Timestamp=2009-01-01T12%3A00%3A00Z&\
Version=2009-01-06);

my $key = "cPVA2YhoyCDVb5YiHjHp6X5H4IIuAtTQ3bSvelby";
my $signature = hmac_sha256_base64($data, $key);
$signature .= '=' while length($signature) % 4;
print "$signature\n";
print URI::Escape::uri_escape($signature), "\n";
