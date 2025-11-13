#!/usr/bin/perl
use strict;
use warnings;

# 检查输入参数
if (@ARGV != 2) {
    die "Usage: perl asv_id_trim.pl <input_file> <output_file>\n";
}

my ($input, $output) = @ARGV;

open(IN, "<", $input) or die "Cannot open input file $input: $!\n";
open(OUT, ">", $output) or die "Cannot open output file $output: $!\n";

while (<IN>) {
    chomp;
    # 将第一列的 ASV000001 替换为 ASV1
    s/^ASV0+(\d+)/ASV$1/;
    print OUT "$_\n";
}

close IN;
close OUT;


