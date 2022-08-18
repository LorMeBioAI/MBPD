import os
import pandas as pd
import argparse
import sys
import time
import subprocess

"""
添加参数模块
"""
parser = argparse.ArgumentParser(description='BacPD')
parser.add_argument('--file',help='Sample table')
parser.add_argument('--pwd', type=str, default='./',help='Output path, default is current path')
parser.add_argument('--similarity', type=float, default=0.9,help='Sequencing regions of V1-V2 or V4 are recommended using 0.9,others are ecommended using 0.8,default=0.9')
args = parser.parse_args()


def progress_bar():
    for i in range(1, 101):
        print("\r", end="")
        print("Running progress: {}%: ".format(i), "▋" * (i // 2), end="")
        sys.stdout.flush()
        time.sleep(0.0005)

def mkdir(path):
    folder = os.path.exists(path)

    if not folder:  # 判断是否存在文件夹如果不存在则创建为文件夹
        os.makedirs(path)  # 创建文件时如果路径不存在会创建这个路径
        print("---  new folder...  ---")

    else:
        print("---  There is this folder!  ---")


"""
获取软件的路径
一定要注意先把相对路径转成绝对路径，不然后面进入输出文件夹就会出问题！
"""
abs=os.path.split(os.path.realpath(__file__))[0]
abs_raw=os.path.realpath(args.file)
abs_db=abs+"/DB"
abs_bin=abs+"/bin"
similarity=args.similarity
print(f"""
The PWD of workplace is: {abs}
The PWD of raw.fq.list is: {abs_raw}
""")


"""
创建文件夹，定义输出路径
"""

# 先读取进来，不然路径不对的话可能会出问题，相对路径发生改变了


# raw_fq_list = pd.read_csv("./Example/raw.fq.list",sep="\t",header=None)

# 创建这个路径，并在这个路径下操作任务
mkdir(args.pwd)
os.chdir(args.pwd)
mkdir("00.Data")
mkdir("01.ASV.tax")
mkdir("shell")


# 读入数据表的绝对路径！
raw_fq_list = pd.read_csv(abs_raw,sep="\t",header=None)
ID_list = raw_fq_list[0]
fq_list = raw_fq_list[1]
num = ID_list.shape[0]

# 常用缩写设置
PWD=os.getcwd()+"/"
abs_shell=PWD+"shell/"
mode = PWD+"shell/"+'S01.1.{}'

"""
定义dada2文件
"""

f = open(mode.format("dada2") + '.r', 'w', encoding='utf-8')
content=(f"""
library(Rcpp)
library(crayon)
library(withr)
library(ggplot2)
library(BiocGenerics)
library(S4Vectors)
library(IRanges)
library(XVector)
library(GenomeInfoDb)
library(matrixStats)
library(Biobase)
library(Matrix)
library(latticeExtra)
library(reshape2)
library(dada2)
##----filenames-------------
path <- "{PWD}00.Data"
fns <- list.files(path, pattern=".fq.gz")
sample.names <- sapply(strsplit(basename(fns), "[.]"), `[`, 1)
sample.names
##----filter and trim-------
filtpath <- file.path(path, "filtered")
filterAndTrim(file.path(path,fns), file.path(filtpath,fns),  maxEE=1, truncQ=2, rm.phix=TRUE, compress=TRUE, verbose=TRUE, multithread=TRUE)
filts <- list.files(filtpath, pattern="fq", full.names=TRUE)
names(filts) <- sample.names
##----learn Errors rate----------
set.seed(100)
err <- learnErrors(filts, nbases = 1e8, multithread=TRUE, randomize=TRUE)
##----Infer sequence variants----
dds <- vector("list", length(sample.names))
names(dds) <- sample.names
for(sam in sample.names) {{
	cat("Processing:", sam, "\\n")
	derep <- derepFastq(filts[[sam]])  ##Dereplication
	dds[[sam]] <- dada(derep, err=err, multithread=TRUE)  ##dada2
}}
##----Construct sequence table---
seqtab <- makeSequenceTable(dds)
saveRDS(seqtab, "./seqtab.rds")
write.table(t(seqtab),"table.xls",sep="/\t")
# Merge multiple runs (if necessary)
#st1 <- readRDS("path/to/run1/output/seqtab.rds")
#st2 <- readRDS("path/to/run2/output/seqtab.rds")
#st3 <- readRDS("path/to/run3/output/seqtab.rds")
#st.all <- mergeSequenceTables(st1, st2, st3)
##----Remove chimeras------------
seqtabrechim <- removeBimeraDenovo(seqtab, method="consensus", multithread=TRUE)
write.table(t(seqtabrechim),"table.rechim.xls",sep="\t")
""")
f.write(content)
f.close()

"""
定义脚本文件
"""
f = open(mode.format("pathogen") + '.sh', 'w', encoding='utf-8')
for i in range(0,num,1):
  # TODO: 循环输出脚本...
  fq = fq_list[i]
  ID = ID_list[i]
  f.write(f'ln -s {fq} {PWD}00.Data/{ID}.fq.gz')
  f.write("\n")


content = (f"""
cd {PWD}01.ASV.tax/
Rscript {abs_shell}S01.1.dada2.r
perl {abs_bin}/dada2normal.pl table.rechim.xls
perl {abs_bin}/asv-generate.pl table.rechim.xls asv.table asv.fa
sed -i 's/"//g' asv_table.tmp.xls
{abs_bin}/sample_order.pl asv_table.tmp.xls {abs_raw} asv_table.xls
rm asv_table.tmp.xls

biom convert -i asv_table.xls -o asv_table.biom --table-type "OTU table" --to-json
{abs_bin}/assign_taxonomy.py -m uclust -i asv_rep.fasta --similarity {similarity} -r {abs_db}/pathogen.fasta -t {abs_db}/pathogen.tax -o assign_taxonomy
{abs_bin}/taxaTable_byAss.pl asv_table.xls assign_taxonomy/asv_rep_tax_assignments.txt asv_taxa_table.xls
biom convert -i asv_taxa_table.xls -o asv_taxa_table.biom --process-obs-metadata taxonomy --table-type "OTU table" --to-json
rm -r assign_taxonomy


""")
f.write(content)
f.close()
# 显示运行成功！
print("""

""")
print(f"""
Please note that your input！！！
file:{args.file}
pwd:{args.pwd}
""")
progress_bar()
