#!/usr/bin/perl
use strict;
use warnings;
use HTML::TagParser;
use Encode;
use HTML::TreeBuilder;
use URI::Escape;
use Digest::SHA qw(hmac_sha256_base64);
use LWP::UserAgent;

my $itemurl ="http://www.amazon.co.jp/%E3%82%B9%E3%83%86%E3%82%A3%E3%83%BC%E3%83%96%E3%83%BB%E3%82%B8%E3%83%A7%E3%83%96%E3%82%BA-%E9%A9%9A%E7%95%B0%E3%81%AE%E3%83%97%E3%83%AC%E3%82%BC%E3%83%B3%E2%80%95%E4%BA%BA%E3%80%85%E3%82%92%E6%83%B9%E3%81%8D%E3%81%A4%E3%81%91%E3%82%8B18%E3%81%AE%E6%B3%95%E5%89%87-%E3%82%AB%E3%83%BC%E3%83%9E%E3%82%A4%E3%83%B3%E3%83%BB%E3%82%AC%E3%83%AD/dp/482224816X/ref=pd_sim_b_3";

my $html = HTML::TagParser->new("$itemurl");

my @listbyline = $html->getElementsByClassName( "byline" );
my @namelist = ();
foreach my $elem (@listbyline){
    my $name = $elem -> innerText;
    
    #$text = decode('Shift_JIS', $text);
    #print $text,"\n";
    chomp($name);
    $name =~ s/^ *(.*?) *$/$1/;

    #$text = encode('UTF-8' , $text );
    $name =~ s/&#[0-9]*//g;
    $name =~ s/\r|\n//;
    $name =~ s/\n//;
    print $name,"\n";#製作者名
    push(@namelist,$name); 
}

=pod
foreach (@namelist){
    print $_,"\n";
}
=cut

 
my $user_agent = "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)";
my $ua = LWP::UserAgent->new(agent => $user_agent);
my $res = $ua->get($itemurl);
my $content = $res->decoded_content;
my $tree = HTML::TreeBuilder->new;
$tree->parse($content);

#「この商品を買った人はこんな商品も買っています」 に表示されている商品のURL
#my @items =  $tree->look_down('class', 'new-faceout fixed-line');
#my @buyitem = ();

#foreach (@items){
#        print $_->find("a")->attr('href'),"\n";
#        push(@buyitem ,$_->find("a")->attr('href'));
#}

my $buyitems = $tree->look_down('id','purchaseSimsData')->as_text;
#print $items,"\n";
my @morebuylist = split(/,/, $buyitems);
print "@morebuylist\n";

my @buylist = ();
foreach (@morebuylist){

    push(@buylist, "http://www.amazon.co.jp/dp/".$_);#「この商品を買った人はこんな商品も買っています」 に表示されている商品のURL 
}
print "@buylist\n";

#商品URLからレビューのURLを取得
my @review =  $tree->look_down('class', 'histogramButton');

#print "================review\n";
#print $review[0]->find("a")->attr('href'),"\n";
my $itemreview = $review[0]->find("a")->attr('href');#商品のレビューのURL


#Reviewの評価

$html = HTML::TagParser->new( "$itemreview" );


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
#            print $indirw,"\n";#個々のレビュー

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



########################################################


#ISBNを受け取り、Amazon APIのリクエストURIを返す関数
sub GetSignedURIByISBN{

    # Amazon Access Key ID
    my $accessKeyID = "AKIAIO4F32K7CCUII6KA";
    # Amazonから割り振られる秘密キー
    my $secretKey   = "cPVA2YhoyCDVb5YiHjHp6X5H4IIuAtTQ3bSvelby";

    # リクエスト先のホスト名
    my $host = "xml-jp.amznxslt.com";
    my $path = "/onca/xml";
	my $associatetag = "associnfinith-22";
    # リクエストキーとパラメータを関連付けた連想配列を用意する
    my %reqParam = (
        "Service"        => "AWSECommerceService",
        "AWSAccessKeyId" => $accessKeyID,
        "Version"        => "2007-10-29",
        "Operation"      => "ItemSearch",#検索
        "Keywords"       => $_[0],
        "SearchIndex"    => "All",
        #"ItemId"         => $_[0], # 引数で受け取ったISBNが入る
        "ResponseGroup"  => "Medium",
        "ContentType"    => "text/xml",
        "Timestamp"      => &GetTimeStamp(),
        "AssociateTag"   => $associatetag
    );

    # リクエストキーとパラメータを結合したクエリを作成
    my @queryList = ();
    foreach my $reqKey(sort(keys%reqParam)){ #アルファベット順にソート
        push(@queryList, URI::Escape::uri_escape($reqKey, "^A-Za-z0-9\-_.~")."=".URI::Escape::uri_escape($reqParam{$reqKey}, "^A-Za-z0-9\-_.~"));
    }
    my $query = join("&", @queryList);

    # 署名を作成
    my $signature = hmac_sha256_base64("GET\n$host\n$path\n$query", $secretKey);
    $signature .= "=" while length($signature) % 4; # 署名の長さが4の倍数になるまで"="を付加
    $signature = URI::Escape::uri_escape($signature, "^A-Za-z0-9\-_.~");

    # リクエストURIを返す
    return "http://$host$path?$query&Signature=$signature";
}

# 呼ばれた時刻のタイムスタンプを返す関数
sub GetTimeStamp {
    my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = gmtime();
    return sprintf("%04d-%02d-%02dT%02d:%02d:%02dZ",
                   $year+1900, $mon+1, $mday, $hour, $min, $sec);
}

# コマンド引数からISBNを受け取り、リクエストURIを表示
print &GetSignedURIByISBN($ARGV[0])."\n";

