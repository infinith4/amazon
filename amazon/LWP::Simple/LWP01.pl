#!/usr/bin/env perl                                                             
use strict;
use warnings;
use LWP::Simple;

my $url = 'http://yahoo.co.jp/';

# LWP::UserAgentのインスタンスを生成                                            
my $ua = LWP::UserAgent->new;

# LWP::UserAgentの「get」メソッドを使用                                         
# 返り値はHTTP::Response                                                        
my $response = $ua->get($url);

if ($response->is_success) {
    my $html = $response->content;
} else {
    die $response->status_line;
}
