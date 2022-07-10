#!/usr/bin/perl -w
use strict;
use warnings;

die "usage: perl $0 otu_table.xls raw.fq.lst output\n" unless(@ARGV == 3);
my ($inputTable,$check,$output) = @ARGV;

my %name;	my @order;
open INC,$check or die "$!\n";
open INT,$inputTable or die "$!\n";	my $head=<INT>;	chomp $head;	my @head=split /\t/,$head;
open OUT,"> $output" or die "$!\n";	print OUT "OTU ID";
foreach my $k(1..$#head){
	$name{$head[$k]}=$k;
}
while(<INC>){
        chomp;  my @a = split /\t/;	push @order,$name{$a[0]};	print OUT "\t$a[0]";
}
close INC;
print OUT "\n";
while(<INT>){
	chomp;	my @a=split /\t/;
	print OUT "$a[0]";
	foreach my $k(@order){
		print OUT "\t$a[$k]";
	}
	print OUT "\n";
}
close INT;	close OUT;
