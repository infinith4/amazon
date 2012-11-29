#!/usr/bin/perl

use strict;
use warnings;
use Encode ;

my $str ;
$str = '%A4%A2%A4%D9+%A4%DE%A4%EA%A4%A2' ;

$str =~ tr/+/ / ;
$str = encode_utf8( $str ) ; # tr/+/ /後にUTF-8フラグを外すこと
$str =~ s/%([a-fA-F0-9]{2})/pack( 'C', hex($1) )/eg ;  

my $result ;
$result = decode( 'euc-jp', $str ) ;
print $result ,"\n";
