#!/usr/bin/perl
use strict;
use warnings;
use URI::Escape;
use Digest::SHA qw(hmac_sha256_base64);

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
        "SearchIndex"    => "Books",
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

#http://ecs.amazonaws.com/onca/xml?Service=AWSECommerceService
#&Version=2011-08-01
#&AssociateTag=PutYourAssociateTagHere
#&Operation=ItemSearch
#&Keywords=harry+potter

#$perl api502.pl harry+potter
