#!/usr/bin/perl
use strict;
use warnings;
use HTML::TagParser;
use Encode;
use HTML::TreeBuilder;
use utf8;
my $url ="http://www.amazon.co.jp/%E3%82%B9%E3%83%86%E3%82%A3%E3%83%BC%E3%83%96%E3%83%BB%E3%82%B8%E3%83%A7%E3%83%96%E3%82%BA-%E9%A9%9A%E7%95%B0%E3%81%AE%E3%83%97%E3%83%AC%E3%82%BC%E3%83%B3%E2%80%95%E4%BA%BA%E3%80%85%E3%82%92%E6%83%B9%E3%81%8D%E3%81%A4%E3%81%91%E3%82%8B18%E3%81%AE%E6%B3%95%E5%89%87-%E3%82%AB%E3%83%BC%E3%83%9E%E3%82%A4%E3%83%B3%E3%83%BB%E3%82%AC%E3%83%AD/dp/482224816X/ref=pd_sim_b_3#次に進む";

my $html = HTML::TagParser->new("$url");

my @list = $html->getElementsByClassName( "byline" );

foreach my $elem (@list){
    my $text = $elem -> innerText;
    
    #$text = decode('Shift_JIS', $text);
    #print $text,"\n";
    chomp($text);
    $text =~ s/^ *(.*?) *$/$1/;

    #$text = encode('UTF-8' , $text );
    $text =~ s/&#[0-9]*//g;
    $text =~ s/\r|\n//;
    $text =~ s/\n//;
    print "==",$text,"\n";
}


=pod

my @listfaceout = $html->getElementsByClassName( "new-faceout fixed-line" );

foreach my $elem (@listfaceout){
    my $url = $elem ->{href};
    #my $text = $elem -> innerText;
    
    #$text = decode('Shift_JIS', $text);
    #print $text,"\n";
    #chomp($text);
    #$text =~ s/^ *(.*?) *$/$1/;

    #$text = encode('UTF-8' , $text );
    #$text =~ s/&#[0-9]*//g;
    #$text =~ s/\r|\n//;
    #$text =~ s/\n//;
    print $url,"\n";
}

=cut 
use LWP::UserAgent;

 
# IE8のフリをする
my $user_agent = "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)";
 
# LWPを使ってサイトにアクセスし、HTMLの内容を取得する
my $ua = LWP::UserAgent->new(agent => $user_agent);
my $res = $ua->get($url);
my $content = $res->decoded_content;
 
# HTML::TreeBuilderで解析する
my $tree = HTML::TreeBuilder->new;
$tree->parse($content);

#「この商品を買った人はこんな商品も買っています」 に表示されている商品

my @items =  $tree->look_down('class', 'new-faceout fixed-line');
foreach (@items){
    foreach my $a ($_->find("a")){
        print $a->attr('href'),"\n";
    }
}
