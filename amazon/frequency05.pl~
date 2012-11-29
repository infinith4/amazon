#!/usr/bin/perl
use strict;
use warnings;
use HTML::TagParser;

my $html = HTML::TagParser->new( "http://www.amazon.co.jp/product-reviews/482224816X/ref=cm_cr_pr_fltrmsg?ie=UTF8&showViewpoints=0" );

#print "good",$gtext1,"\n";
#print "bad",$btext1,"\n";
#my $text = $html->innerText();
#print $html;
#my $text = $html;
my $elem = $html->getElementsByTagName( "body" );
my $text = $elem -> innerText();

#print $text;
my $pre="レビュー対象商品";

if ($text =~ m/$pre/) {
    print "pre match:$`\n";
    print "post match:$'\n";
}

my @file = ("./goodlist.txt","./badlist.txt");

#my $file = "./goodlist.txt"; # 読み込みたいファイル名
my $allcnt = 0;

    my $gfile = $file[0];
    open( my $gfh, "<", $gfile )
        or die "Cannot open $gfile: $!";

    while( my $line = readline $gfh ){ 
        # readline関数で、一行読み込む。
        
        chomp $line; # chomp関数で、改行を取り除く
        
        # $line に対して何らかの処理。
        my $str = $text;
        my $cnt = (() = $str =~ /$line/g);
        $allcnt += $cnt;

        #print "$line:",$cnt,"\n";

        # ファイルがEOF( END OF FILE ) に到達するまで1行読みこみを繰り返す。
    }
    print "\$allcnt:$allcnt","\n";
close $gfh;

my $ballcnt = 0;
my $str = "";

print "\$allcnt:$allcnt\n";
print "================badlist\n";
    my $bfile = $file[1];
    open( my $bfh, "<", $bfile )
        or die "Cannot open $bfile: $!";

while( my $line = readline $bfh ){ 
        # readline関数で、一行読み込む。
        
        chomp $line; # chomp関数で、改行を取り除く
        
        # $line に対して何らかの処理。
        my $str = $text;
        my $cnt = (() = $str =~ /$line/g);
        $ballcnt += $cnt;

        #print "$line:",$cnt,"\n";

        # ファイルがEOF( END OF FILE ) に到達するまで1行読みこみを繰り返す。
    }
    #print "\$ballcnt:$ballcnt","\n";

# 以下は簡潔な記述。<$fh> という記述は
# readline $fh を意味する。 
=pod
    while( my $line = <$fh> ){
        print $line;
}
=cut
    print "$ballcnt\n";

    close $bfh;

