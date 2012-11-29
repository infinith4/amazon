#!/usr/bin/perl
use strict;
use warnings;
use Digest::SHA qw(hmac_sha256_base64);
use URI::Escape qw(uri_escape);
use CGI;
use LWP::Simple;
use POSIX qw(strftime);

my $q = new CGI;

my %pkv;
foreach my $k ($q->param) {
    $pkv{$k} = $q->param($k);
}
$pkv{"Timestamp"} = strftime("%Y-%m-%dT%H:%M:%SZ", gmtime);

my $pstr = join('&', map {"$_=".uri_escape($pkv{$_})} (sort keys %pkv));
my $data = "GET\nwebservices.amazon.co.jp\n/onca/xml\n$pstr";
my $key = "cPVA2YhoyCDVb5YiHjHp6X5H4IIuAtTQ3bSvelby";
my $signature = hmac_sha256_base64($data, $key);
$signature .= '=' while length($signature) % 4;
$signature = URI::Escape::uri_escape($signature);

my $aurl = qq(http://webservices.amazon.co.jp/onca/xml?)
    .qq($pstr&Signature=$signature);

print $q->header(-type=>'text/xml; charset=UTF-8');
print get($aurl) || "";
print "\n";
