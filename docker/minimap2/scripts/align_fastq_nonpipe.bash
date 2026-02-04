#!/bin/bash
FASTQ=$1

/opt/conda/bin/minimap2 \
    -a ${REF_FASTA}.mmi \
    -L \
    $FASTQ \
    | samtools addreplacerg -u -r "ID:${FASTQ%.fastq.gz}" -r "SM:${FULLSMID}" - \
    | samtools sort -O BAM -o ${FASTQ%.fastq.gz}.aln.srt.bam