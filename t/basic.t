#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;

use FindBin qw/$Bin/;
use lib "$Bin/../lib";

use Data::Dumper::Store;
use Test::More;

my $file = 'test.txt';

eval { Data::Dumper::Store->new() };
ok $@;

my $data = {
    key1 => 'val-1',
    key2 => 'val-2'
};

{
    ok my $store = Data::Dumper::Store->new(file => $file);

    ok $store->init($data);
    ok $store->get('key1');
    ok $store->get('key2');
    is_deeply $store->{data}, $data;
}

{
    ok my $store2 = Data::Dumper::Store->new(file => $file);
    is_deeply $store2->{data}, $data;

    ok $store2->set('key3', 'val-3');
    is $store2->get('key3'), 'val-3';
    is $store2->set('key3', 'val-4')->get('key3'), 'val-4';

    ok $store2->commit();
}

{
    ok my $store3 = Data::Dumper::Store->new(file => $file);
    is $store3->get('key3'), 'val-4';
}

unlink $file;


done_testing();