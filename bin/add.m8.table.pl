#!usr/bin/perl -w
use strict;
die "usage:perl $0 <asv_table.xls> <m8.txt.fil>\n" unless @ARGV == 2;
open A,$ARGV[0]; open B,$ARGV[1]; my $h=<A>; chomp $h; my @h=split /\t/,$h; 
open O1,">asv_taxa_table.xls";
open O2,">asv_taxa_table.no.unclassified.xls";
open O3,">unassigned.stat.txt";
print O1 "$h\tGenomeID\n"; print O2 "$h\tGenomeID\n";
my %map; my %stat; 
foreach my $k(1..$#h){
	$stat{$h[$k]}[0]=0; $stat{$h[$k]}[1]=0;
}
while(<B>){
	chomp;my @a=split /\t/; $map{$a[0]}=$a[1];
}
while(<A>){
	chomp;my @a=split /\t/; 
	foreach my $k(1..$#a){
		$stat{$h[$k]}[0]+=$a[$k];
	}
	if(exists $map{$a[0]}){
		print O1 "$_\t$map{$a[0]}\n";
		print O2 "$_\t$map{$a[0]}\n";
	}
	else{
		print O1 "$_\tunclassified\n";
		foreach my $k(1..$#a){
			$stat{$h[$k]}[1]+=$a[$k];
		}
	}
}
print O3 "SampleID\tAllReads\tUnclassifiedReads\tUnclassifiedRate%\n";
foreach my $k(sort keys %stat){
	my $rate=int(10000*$stat{$k}[1]/$stat{$k}[0])/100; 
	print O3 "$k\t$stat{$k}[0]\t$stat{$k}[1]\t$rate\n";
}
