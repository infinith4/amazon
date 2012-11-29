#!/usr/bin/perl

use LWP::Simple;
print "Content-type: text/html; \n\n";
#例としてYahooのページを取得します
$html = get("http://www.yahoo.co.jp/");
print $html;
