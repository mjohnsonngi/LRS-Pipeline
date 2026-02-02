#!/bin/bash
FASTQS=$(find ${INDIR}/ -name "*.fastq.gz" | sort )
IFS=$'\n' read -d '' -r -a FQARRAY <<< "$FASTQS"

FASTQ=${FQARRAY[$((LSB_JOBINDEX - 1))]}

echo $FASTQ

/opt/conda/bin/minimap2 \
    -a ${REF_FASTA}.mmi \
    -L \
    $FASTQ \
    | samtools addreplacerg -r "ID:${FASTQ%.fastq.gz}" -r "SM:${FULLSMID}" \
    | samtools sort -O BAM -o ${FASTQ%.fastq.gz}.aln.srt.bam