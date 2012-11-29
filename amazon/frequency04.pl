#!/usr/bin/perl
use strict;
use warnings;
use HTML::TagParser;
use Encode;
#my $html = HTML::TagParser->new( "http://www.amazon.co.jp/product-reviews/482224816X/ref=cm_cr_pr_fltrmsg?ie=UTF8&showViewpoints=0" );
my $html = HTML::TagParser->new("http://www.amazon.co.jp/product-reviews/B007KUZ33W/ref=cm_cr_dp_see_all_top?ie=UTF8&showViewpoints=1");

#print "good",$gtext1,"\n";
#print "bad",$btext1,"\n";
#my $text = $html->innerText();
#print $html;
#my $text = $html;
my $elem = $html->getElementsByTagName( "body" );

#my @title = $html -> getElementsByAttribute("href" ,"a");

#print "@title\n";

my $text = $elem -> innerText();
$text = decode('Shift_JIS', $text);
#print $text;
chomp($text);
$text =~ s/^ *(.*?) *$/$1/;

$text = encode('UTF-8' , $text );

#print $text;
my $title = $html->getElementsByTagName( "title" );
$title =  $title-> innerText();
$title = decode('Shift_JIS', $title);
$title = encode('UTF-8' , $title );

my $producttitle = "";
if($title =~ m/カスタマーレビュー: /){
    #print "title:$'\n";
    $producttitle = "$'";#商品名を取得
    if($producttitle =~ m/\(|（|\[|［/ ){
        $producttitle = "$`";
    }
}


my $pre = "レビュー対象商品:";
my $post = "レビューを評価してください";

for(my $i = 0;$i < 10 ;$i++ ){
    my $indirw = "";#individual review
    my $nexttext = "";
    if ($text =~ m/$pre/ ) {
        $indirw = "$'";#$pre 以降

        if($indirw =~ m/$post/){
            #print "match:$`\n";
            $indirw = "$`";#$post 以前
            $nexttext = "$'";#次のtext
            #print $nexttext,"\n";
            $indirw =~ s/$producttitle//g;
            print $indirw,"\n";#個々のレビュー

        }
    }
    $text = $nexttext;


    my @file = ("./goodlist.txt","./badlist.txt");

#my $file = "./goodlist.txt"; # 読み込みたいファイル名
    my $gallcnt = 0;
    my $gfile = $file[0];
    open( my $gfh, "<", $gfile )
        or die "Cannot open $gfile: $!";

    while( my $line = readline $gfh ){ 
        # readline関数で、一行読み込む。
        
        chomp $line; # chomp関数で、改行を取り除く
        
        my $str = $indirw;
        my $cnt = (() = $str =~ /$line/g);
        $gallcnt += $cnt;

        #print "$line:",$cnt,"\n";

    }
    print "goodallcnt:$gallcnt","\n";
    close $gfh;

    my $ballcnt = 0;
    my $str = "";

#print "badlist\n";
    my $bfile = $file[1];
    open( my $bfh, "<", $bfile )
        or die "Cannot open $bfile: $!";

    while( my $line = readline $bfh ){ 
        # readline関数で、一行読み込む。
        
        chomp $line; # chomp関数で、改行を取り除く
        
        # $line に対して何らかの処理。
        my $str = $indirw;
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
    print "badallcnt:$ballcnt\n";

    close $bfh;
}
