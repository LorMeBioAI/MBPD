die "perl asv-generate.pl table.rechim.xls asv.table asv.fa\n" if(@ARGV!=3);
my ($line,@inf);
my $n=0;
open IN, "$ARGV[0]" or die "can not open file: $ARGV[0]\n";
open OA, ">$ARGV[1]" or die "can not open file: $ARGV[1]\n";
open OB, ">$ARGV[2]" or die "can not open file: $ARGV[2]\n";
$line=<IN>;chomp $line;$line=~s/\"//g;
print OA "ID\t$line\n";
while($line=<IN>){
	chomp $line;
	$line=~s/\"//g;
	@inf=split /\t/,$line;
	$n++;
	$temp=sprintf("%06s","$n");
	print OB ">ASV$temp\n$inf[0]\n";
	$line=join("\t",@inf[1..$#inf]);
	print OA "ASV$temp\t$line\n";
}
close IN;
close OA;
close OB;
