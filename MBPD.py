import os
import pandas as pd
import argparse
import sys
import time
import subprocess

# 添加参数模块
parser = argparse.ArgumentParser(description='BacPD')
parser.add_argument('--file', help='Sample table')
parser.add_argument('--pwd', type=str, default='./', help='Output path, default is current path')
parser.add_argument('--similarity', type=float, default=0.9, 
                    help='Recommended similarity: 0.9 for V1-V2/V4, 0.8 for others, default=0.8')
args = parser.parse_args()

def progress_bar():
    for i in range(1, 101):
        print("\r", end="")
        print(f"Running progress: {i}%: ", "▋" * (i // 2), end="")
        sys.stdout.flush()
        time.sleep(0.005)

def mkdir(path):
    if not os.path.exists(path):
        os.makedirs(path)
        print(f"--- Created new folder: {path} ---")
    else:
        print(f"--- Folder already exists: {path} ---")

# 获取软件路径，转换为绝对路径
abs_path = os.path.split(os.path.realpath(__file__))[0]
abs_raw = os.path.realpath(args.file)
abs_db = os.path.join(abs_path, "db")
abs_bin = os.path.join(abs_path, "bin")
similarity = args.similarity

print(f"""
The PWD of workplace is: {abs_path}
The PWD of raw.fq.list is: {abs_raw}
""")

# 创建文件夹和输出路径
mkdir(args.pwd)
os.chdir(args.pwd)
mkdir("00.Data")
mkdir("01.ASV.tax")
mkdir("shell")

# 读入数据表
raw_fq_list = pd.read_csv(abs_raw, sep="\t", header=None)
ID_list = raw_fq_list[0]
fq_list = raw_fq_list[1]
num = ID_list.shape[0]

# 常用路径设置
PWD = os.getcwd() + "/"
abs_shell = PWD + "shell/"
mode = PWD + "shell/S01.1.{}"

# 生成第一部分脚本 (S01.1.pathogen.part1.sh)
with open(mode.format("pathogen.part1") + '.sh', 'w', encoding='utf-8') as f1:
    content1 = f"""
cd {PWD}01.ASV.tax/
Rscript {abs_shell}S01.1.dada2.r
perl {abs_bin}/dada2normal.pl table.rechim.xls
perl {abs_bin}/asv-generate.pl table.rechim.xls asv.table asv.fa
sed -i 's/"//g' asv_table.tmp.xls

echo "First part of the script completed successfully."
"""
    f1.write(content1)

# 生成第二部分脚本 (S01.1.pathogen.part2.sh)
with open(mode.format("pathogen.part2") + '.sh', 'w', encoding='utf-8') as f2:
    content2 = f"""
cd {PWD}01.ASV.tax/
##########
chmod 777 {abs_bin}/uclust
{abs_bin}/uclust --input asv_rep.fasta --id {similarity} --rev --maxaccepts 3 --allhits --libonly --lib {abs_db}/pathogen.fasta --uc asv_rep_tax_assignments.uc
python {abs_bin}/asv_rep_tax_assignments.py -t {abs_db}/pathogen.tax -u asv_rep_tax_assignments.uc -o ./asv_rep_tax_assignments.txt
perl {abs_bin}/taxaTable_byAss.pl asv_table.tmp.xls asv_rep_tax_assignments.txt asv_taxa_table.xls

echo "Second part of the script completed successfully."
"""
    f2.write(content2)

# 生成 R 脚本 (S01.1.dada2.r)
with open(mode.format("dada2") + '.r', 'w', encoding='utf-8') as r_file:
    r_content = f"""
library(dada2)
path <- "{PWD}00.Data"
fns <- list.files(path, pattern=".fq.gz")
sample.names <- sapply(strsplit(basename(fns), "[.]"), `[`, 1)
filtpath <- file.path(path, "filtered")
filterAndTrim(file.path(path, fns), file.path(filtpath, fns), maxEE=1, truncQ=2, rm.phix=TRUE, compress=TRUE, multithread=TRUE)
filts <- list.files(filtpath, pattern="fq", full.names=TRUE)
names(filts) <- sample.names
set.seed(100)
err <- learnErrors(filts, nbases = 1e8, multithread=TRUE)
dds <- lapply(sample.names, function(sam) {{
    derep <- derepFastq(filts[[sam]])
    dada(derep, err=err, multithread=TRUE)
}})
seqtab <- makeSequenceTable(dds)
saveRDS(seqtab, "./seqtab.rds")
write.table(t(seqtab), "table.xls", sep="\t")
seqtabrechim <- removeBimeraDenovo(seqtab, method="consensus", multithread=TRUE)
write.table(t(seqtabrechim), "table.rechim.xls", sep="\t")
"""
    r_file.write(r_content)

# 生成符号链接的脚本
with open(mode.format("symbolic_links") + '.sh', 'w', encoding='utf-8') as f_link:
    for i in range(num):
        f_link.write(f'ln -s {fq_list[i]} {PWD}00.Data/{ID_list[i]}.fq.gz\n')

# 运行第一部分和第二部分脚本
def run_shell_script(script):
    result = subprocess.run(['bash', script], capture_output=True, text=True)
    print(result.stdout)
    if result.returncode != 0:
        print(f"Error running {script}:\n{result.stderr}")

print("Running first part of the script...")
run_shell_script(mode.format("pathogen.part1") + '.sh')

print("First part completed. Now running the second part...")
run_shell_script(mode.format("pathogen.part2") + '.sh')

print("All tasks completed successfully!")
progress_bar()
