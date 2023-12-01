# MBPD: A multiple bacterial pathogen detection pipeline for One Health practices

## Contents

- [Introduction](#introduction)
- [Citation](#Citation)
- [Requirement](#requirement)
- [Basic Usage](#basic-usage)
- [Example dataset](#example-dataset)
- [Contact](#Contact)

## Introduction

MBPD is a bioinformatics analysis pipeline used for the multiple defection of bacterial pathogens based on the 16S rRNA gene sequencing. We first developed a curated reference database of bacterial pathogens (MBPD database) from various literatures and databases, such as Bull et al. (2010, 2012, 2014), PATRIC, 16SPIP, FAPROTAX, etc. MBPD database consists of 72685 16S full-length sequences of animal, plant and zoonotic pathogen belonging to 18 phyla, 29 classes, 77 orders, 169 families, 440 genera and 1986 species. Clean data of 16S sequencing of both environmental and biological samples is processed using DADA2 pipeline  to obtain amplicon sequence variants (ASVs). Finally, sequences of ASV are aligned to the MBPD reference database using UCLUST algorithm with an optimal similarity threshold according to the full-length or variable sub-region of 16S.

## Citation

If you are using MBPD in your research, please cite the following paper:

Yang X, Jiang G, Zhang Y, et al. MBPD: A multiple bacterial pathogen detection pipeline for one health practices, iMeta 2023;2:e82.

doi: 10.1002/imt2.82

## Requirements

1.	Python 3
2.	QIIME1
3.	QIIME2
4.	Biom
5.	R environment with packages (Rcpp, crayon, withr, ggplot2, BiocGenerics, S4Vectors, IRanges, XVector, GenomeInfoDb, matrixStats, Biobase, Matrix, latticeExtra, reshape2, dada2).

Note: To ensure  the script works properly, you need to install qiime1 in the default environment and install qimme2 in another conda environment, and conda activate qiime2 to run the commands related to ASVs and taxonomic assignment.

## Basic Usage

Using python3 MBPD.py -h to see the help page

optional arguments:
  -h, --help	show the help page of MBPD
  --file FILE	Sample table
  --pwd PWD 	Output path, default is current path
  --similarity SIMILARITY	The similarity of uclust,sequencing regions of V1-V2 or V4 are recommended using 0.9,others are ecommended using 0.8,default=0.8.

Step 1: manually create a sample table 
--file: a sample table as an input, e.g., raw.fq.list, the separator is line break. Here is an example, fastq files are sequences removed primer and barcode)

Sample1 /path/valid/Sample1.fq  
Sample2 /path/valid/Sample2.fq

Step 2: choose the output path
--pwd Output path, default is current path

Step 3: choose the appropriate threshold for pathogen identification
--similarity: The threshold of taxonomy classification based on uclust algorithm,sequencing regions of V1-V2 or V4 are recommended using 0.9,others are ecommended using 0.8,default=0.8, the similarity threshold is (0, 1).

Using following command, and run the S01.1.pathogen.sh script in shell folder. 
python3 MBPD.py --file raw.fq.list --pwd new --similarity 0.9
The output contains fasta file of ASV and table file of pathogenic taxonomy.
asv_taxa_table.xls: table files with taxa as rows and sample as columns.
asv.fa: the fasta file of ASVs

## Example Dataset

Here, we provide a 16S rDNA V4 region data of 20 samples.
You can download the data in the link below, then unzip them.
Link：https://pan.baidu.com/s/1ceS9FzdNqvM-W7WORNAmtg code：436d 

python3 MBPD.py --file example/raw.fq.list --pwd new --similarity 0.9
cd shell/
sh S01.1.pathogen.sh

## Contact

For any questions or issues regarding MBPD, please contact us at xinrunyang@stu.njau.edu.cn.
