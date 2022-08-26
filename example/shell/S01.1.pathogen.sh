ln -s /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/valid/SRR9131790.fq /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/new/00.Data/SRR9131790.fq.gz
ln -s /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/valid/SRR9131794.fq /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/new/00.Data/SRR9131794.fq.gz
ln -s /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/valid/SRR9131795.fq /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/new/00.Data/SRR9131795.fq.gz
ln -s /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/valid/SRR9131796.fq /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/new/00.Data/SRR9131796.fq.gz
ln -s /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/valid/SRR9131797.fq /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/new/00.Data/SRR9131797.fq.gz
ln -s /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/valid/SRR9131798.fq /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/new/00.Data/SRR9131798.fq.gz
ln -s /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/valid/SRR9131799.fq /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/new/00.Data/SRR9131799.fq.gz
ln -s /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/valid/SRR9131800.fq /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/new/00.Data/SRR9131800.fq.gz
ln -s /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/valid/SRR9131801.fq /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/new/00.Data/SRR9131801.fq.gz
ln -s /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/valid/SRR9131802.fq /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/new/00.Data/SRR9131802.fq.gz
ln -s /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/valid/SRR9131803.fq /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/new/00.Data/SRR9131803.fq.gz
ln -s /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/valid/SRR9131804.fq /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/new/00.Data/SRR9131804.fq.gz
ln -s /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/valid/SRR9131805.fq /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/new/00.Data/SRR9131805.fq.gz
ln -s /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/valid/SRR9131806.fq /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/new/00.Data/SRR9131806.fq.gz
ln -s /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/valid/SRR9131807.fq /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/new/00.Data/SRR9131807.fq.gz
ln -s /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/valid/SRR9131808.fq /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/new/00.Data/SRR9131808.fq.gz
ln -s /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/valid/SRR9131809.fq /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/new/00.Data/SRR9131809.fq.gz
ln -s /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/valid/SRR9131810.fq /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/new/00.Data/SRR9131810.fq.gz
ln -s /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/valid/SRR9131811.fq /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/new/00.Data/SRR9131811.fq.gz
ln -s /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/valid/SRR9131812.fq /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/new/00.Data/SRR9131812.fq.gz

cd /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/new/01.ASV.tax/
Rscript /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/new/shell/S01.1.dada2.r
perl /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/bin/dada2normal.pl table.rechim.xls
perl /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/bin/asv-generate.pl table.rechim.xls asv.table asv.fa
sed -i 's/"//g' asv_table.tmp.xls
/mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/bin/sample_order.pl asv_table.tmp.xls /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/example/raw.fq.list20 asv_table.xls
rm asv_table.tmp.xls

biom convert -i asv_table.xls -o asv_table.biom --table-type "OTU table" --to-json
/mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/bin/assign_taxonomy.py -m uclust -i asv_rep.fasta --similarity 0.9 -r /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/DB/pathogen.fasta -t /mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/DB/pathogen.tax -o assign_taxonomy
/mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/bin/taxaTable_byAss.pl asv_table.xls assign_taxonomy/asv_rep_tax_assignments.txt asv_taxa_table.xls
biom convert -i asv_taxa_table.xls -o asv_taxa_table.biom --process-obs-metadata taxonomy --table-type "OTU table" --to-json
rm -r assign_taxonomy


