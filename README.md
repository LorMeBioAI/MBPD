# MBPD: A multiple bacterial pathogen detection pipeline for One Health practices

## Contents

- [Introduction](#introduction)
- [Citation](#citation)
- [Installation & Requirements](#installation--requirements)
- [Basic Usage](#basic-usage)
- [Example dataset](#example-dataset)
- [Contact](#contact)

## Introduction
![MBPD](https://github.com/LorMeBioAI/MBPD/blob/main/pic/workflow.png)
MBPD is a bioinformatics analysis pipeline used for the multiple defection of bacterial pathogens based on the 16S rRNA gene sequencing. We first developed a curated reference database of bacterial pathogens (MBPD database) from various literatures and databases, such as Bull et al. (2010, 2012, 2014), PATRIC, 16SPIP, FAPROTAX, etc. MBPD database consists of 72685 16S full-length sequences of animal, plant and zoonotic pathogen belonging to 18 phyla, 29 classes, 77 orders, 169 families, 440 genera and 1986 species. Clean data of 16S sequencing of both environmental and biological samples is processed using DADA2 pipeline  to obtain amplicon sequence variants (ASVs). Finally, sequences of ASV are aligned to the MBPD reference database using UCLUST algorithm with an optimal similarity threshold according to the full-length or variable sub-region of 16S.

__The new MBPD database containing pathogens and nonpathogens is available on Zenodo(https://doi.org/10.5281/zenodo.10888870).__

## Citation

If you are using MBPD in your research, please cite the following paper:

Yang X, Jiang G, Zhang Y, et al. MBPD: A multiple bacterial pathogen detection pipeline for one health practices, iMeta 2023;2:e82.

Link: https://onlinelibrary.wiley.com/doi/10.1002/imt2.82

## Installation & Requirements
We now support installing with conda directly:
```
git clone https://github.com/LorMeBioAI/MBPD
cd MBPD
conda env create -f MBPD_env.yml
conda activate MBPD
sh MBPD_prepare.sh
```

The detailed dependencies are followed:
1.	Python 3
2.	QIIME2
3.	Biom
4.	R environment with packages (Rcpp, crayon, withr, ggplot2, BiocGenerics, S4Vectors, IRanges, XVector, GenomeInfoDb, matrixStats, Biobase, Matrix, latticeExtra, reshape2, dada2).

Note: Please give bin/uclust enough permissions. For example, run 'chmod 777 uclust'. Additionally, we also provide a blast-based method for taxonomy assignment.

## Basic Usage

Using __MBPD_integrated -h__ to see the help page


options:

  -h, --help            show this help message and exit
  
  --file FILE           Sample table
  
  --pwd PWD             Output path, default is current path
  
  --tool TOOL           taxonomic assignment tools: uclust or blastn
  
  --db DB               reference database: full-db or pathogen-only
  
  --similarity SIMILARITY
                        Recommended similarity of Uclust: 0.9 for V1-V2/V4, 0.8 for others, default=0.8
                        Recommended similarity of blastn: 0.97

Step 1: manually create a sample table (tab delimiter)
--file: a sample table as an input, e.g., raw.fq.list, the separator is line break. Here is an example, fastq files are sequences removed primer and barcode)

Sample1 /path/Sample1.fq  
Sample2 /path/Sample2.fq

Step 2: choose the output path
--pwd Output path, default is current path

Step 3: choose the sequences taxonomic assignment algorithm
--tool: The algorithm would be used for ASVs alignment. Uclust or blastn.

Step 4: choose the reference database 
--db: We here provide two versions, "pahogen-only" and "full-db". "pahogen-only" only containing information about pathogenic bacteria, "full-db" containing both pathogenic and nonpathogenic species and were labeled with "t__nonpathogen", "t__Animal", "t__Zoonotic", and "t__Plant".

__*if you want to use the "full-db", download the database from Zenodo(https://doi.org/10.5281/zenodo.10888870) and move to {your_dir}/MBPD/db.__
 

## Example Dataset

Here, we provide a 16S rDNA V4 region data of 20 samples.
You can download the data in the link below, then unzip them.
Link：https://zenodo.org/records/17055172

__Note: Please revise raw.fq.list based on your fastq path, sep='\t'!__ 

```
cd example/
MBPD_integrated --file raw.fq.list --pwd combination_test_uclust --similarity 0.9 --db pathogen-only --tool uclust
```

If the script does not produce any results, try as followed to see detailed error:
```
cd shell/
sh S01.1.symbolic_links.sh
sh S01.1.pathogen.part1.sh
sh S01.1.pathogen.part2.sh
```
And we are also very glad to help you solve all your problems.

## Contact

For any questions or issues regarding MBPD, please contact us at xinrunyang@stu.njau.edu.cn or shiny@stu.njau.edu.cn.
