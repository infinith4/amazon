use strict;
use warnings;

use strict;
use warnings;
use LWP::UserAgent;
use HTML::TreeBuilder;

# urlを指定する
my $url = 'http://www.amazon.co.jp/product-reviews/4062180731/ref=cm_cr_dp_see_all_top?ie=UTF8&showViewpoints=1';

# IE8のフリをする
my $user_agent = "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)";

# LWPを使ってサイトにアクセスし、HTMLの内容を取得する
my $ua = LWP::UserAgent->new('agent' => $user_agent);
my $res = $ua->get($url);
my $content = $res->content;

# HTML::TreeBuilderで解析する
my $tree = HTML::TreeBuilder->new;
$tree->parse($content);

# DOM操作してトピックの部分だけ抜き出す。
# <div id='topicsfb'><ul><li>....の部分を抽出する

my @items =  $tree->look_down('class', 'tiny')->find('span');
print $_->as_text."\n" for @items;
