# BacPD: Open-view bacterial pathogen detection for One Health perspective

## Contents

- [Introduction](#introduction)
- [Requirement](#requirement)
- [Basic Usage](#basic-usage)
- [Example dataset](#example-dataset)

## Introduction

BacPD is a bioinformatics analysis pipeline used for the open-view defection of bacterial pathogens based on the 16S rDNA amplicon sequencing. We first developed a curated reference database of bacterial pathogens (BacPD database) from various literatures and databases, such as Bull et al. (2010, 2012, 2014), PATRIC, 16SPIP, FAPROTAX, etc. BacPD database compress 72685 16S rDNA gene sequences of animal, plant and zoonotic pathogen belonging to 18 phyla, 29 classes, 77 orders, 169 families, 440 genera and 1986 species. Clean data of 16S rDNA sequencing of both environmental and biological samples are processed using DADA2 pipeline to obtain the sequences of the amplicon sequence variants (ASVs). The cleaned ASVs sequences are aligned to the BacPD reference database using UCLUST algorithm with an appropriate similarity according to the variable region of 16S rDNA sequencing.

## Requirements

1.	Python 3
2.	QIIME1
3.	QIIME2
4.	Biom
5.	R environment with packages (Rcpp, crayon, withr, ggplot2, BiocGenerics, S4Vectors, IRanges, XVector, GenomeInfoDb, matrixStats, Biobase, Matrix, latticeExtra, reshape2, dada2).

## Basic Usage

Using python3 BacPD.py -h to see the help page

optional arguments:
  -h, --help	show the help page of BacPD
  --file FILE	Sample table
  --pwd PWD 	Output path, default is current path
  --similarity SIMILARITY	The similarity of uclust, default=0.9

Step 1: manually create a sample table 
--file: a sample table as an input, e.g., raw.fq.list, the separator is line break. Here is an example, fastq files are primer, barcode and low-quality have trimmed 16S rDNA sequences.
Sample1	/path/valid/Sample1.fq
Sample2	/path/valid/Sample2.fq

Step 2: choose the output path
--pwd Output path, default is current path

Step 3: choose the appropriate threshold for pathogen identification
--similarity: The threshold of taxonomy classification based on uclust algorithm, default=0.9, the similarity threshold is (0, 1).

Using following command, and run the S01.1.pathogen.sh script in shell folder. 
python3 BacPD.py --file raw.fq.list --pwd new --similarity 0.9
The output contains fasta file of ASV and table file of pathogenic taxonomy.
asv_taxa_table.xls: table files with taxa as rows and sample as columns.
asv.fa: the fasta file of ASVs

## Example Dataset

Here, we provide a demo dataset profiling results of 20 samples.
You can download the data in the link below, then unzip them.
Link：https://pan.baidu.com/s/1ceS9FzdNqvM-W7WORNAmtg code：436d 

python3 BacPD.py --file example/raw.fq.list --pwd new --similarity 0.9
cd shell/
sh S01.1.pathogen.sh
