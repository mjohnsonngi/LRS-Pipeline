#!/bin/bash
FASTQ=$1

/opt/conda/bin/minimap2 \
    -a ${REF_FASTA}.mmi \
    $FASTQ \
    | samtools sort -b -o ${FASTQ%.fastq.gz}.aln.srt.bam