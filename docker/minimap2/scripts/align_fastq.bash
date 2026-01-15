#!/bin/bash
FASTQS=($@)
FASTQ=${FASTQS[$((LSB_JOBINDEX - 1))]}
echo ${FASTQS[@]}
echo $FASTQ

/opt/conda/bin/minimap2 \
    -a ${REF_FASTA}.mmi \
    $FASTQ \
    | samtools sort -O BAM -o ${FASTQ%.fastq.gz}.aln.srt.bam