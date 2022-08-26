
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
path <- "/mnt/sdd/wangyu/yxr/pathogen_16s/shrimp/MBPD/new/00.Data"
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
for(sam in sample.names) {
	cat("Processing:", sam, "\n")
	derep <- derepFastq(filts[[sam]])  ##Dereplication
	dds[[sam]] <- dada(derep, err=err, multithread=TRUE)  ##dada2
}
##----Construct sequence table---
seqtab <- makeSequenceTable(dds)
saveRDS(seqtab, "./seqtab.rds")
write.table(t(seqtab),"table.xls",sep="/	")
# Merge multiple runs (if necessary)
#st1 <- readRDS("path/to/run1/output/seqtab.rds")
#st2 <- readRDS("path/to/run2/output/seqtab.rds")
#st3 <- readRDS("path/to/run3/output/seqtab.rds")
#st.all <- mergeSequenceTables(st1, st2, st3)
##----Remove chimeras------------
seqtabrechim <- removeBimeraDenovo(seqtab, method="consensus", multithread=TRUE)
write.table(t(seqtabrechim),"table.rechim.xls",sep="	")
