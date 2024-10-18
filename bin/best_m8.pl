#!usr/bin/perl -w

use strict;

die "usage:perl $0 <m8> \n" unless @ARGV == 1;

open A,$ARGV[0];
my %fun;        my %tar;
while(<A>){
        chomp;my @a=split;      $tar{$a[0]}{$a[-1]}=$_;
        }
        close A;
        foreach my $k1(sort keys %tar){
                foreach my $k3(sort {$b<=>$a} keys %{$tar{$k1}}){
                                print "$tar{$k1}{$k3}\n";
                                                last;
                                                        }
 }
