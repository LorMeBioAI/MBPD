#!usr/bin/perl -w

use strict;
die "usage:perl $0 <table.rechim.xls> \n" unless @ARGV == 1;

open A,$ARGV[0]; open O1,">asv_table.tmp.xls"; open O2,">asv_rep.fasta"; open O3,">seqNum.txt";
my $h=<A>;	chomp $h; my @h=split /\t/,$h;	print O1 "OTU ID\t$h\n";
my %acc;	my %record;	my %total;
while(<A>){
	chomp;my @a=split /\t/;
	foreach my $k(1..$#a){
		$acc{$.}+=$a[$k];	my $pos=$k-1;	$total{$h[$pos]}+=$a[$k];
	}
	$record{$.}[0]=$a[0];	$record{$.}[1]=join "\t",@a[1..$#a];
}
close A;
my $num=0;
foreach my $k(sort {$acc{$b}<=>$acc{$a}} keys %acc){
	$num++;
	print O1 "ASV$num\t$record{$k}[1]\n";
	print O2 ">ASV$num $acc{$k}\n$record{$k}[0]\n";
}
close O1; close O2;
print O3 "#Sample\tSeqNum\n";
foreach my $k(@h){
	print O3 "$k\t$total{$k}\n";
}
