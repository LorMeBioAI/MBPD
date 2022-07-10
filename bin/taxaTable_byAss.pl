#!/usr/bin/perl -w
use strict;
use warnings;

die "usage: perl $0 otu_table.xls assign_taxonomy.txt output\n" unless(@ARGV == 3);
my ($table,$taxFile,$output) = @ARGV;

my %tax;
open INT,$taxFile or die "$!\n";
while(<INT>){
	chomp;
	my @temp = split /\t/;
	$temp[1] = "Unclassified" if($temp[1] eq "Unassigned");
	$tax{$temp[0]} = $temp[1];
}
close INT;

open IN,$table or die "$!\n";
open OUT,"> $output" or die "$!\n";
while(<IN>){
	chomp;
	if($. == 1){
		print OUT "$_\ttaxonomy\n";
	}else{
		my @temp = split /\t/;
		die "errro: $_\n" unless(exists $tax{$temp[0]});
		print OUT "$_\t$tax{$temp[0]}\n";
	}
}
close IN;
close OUT;
