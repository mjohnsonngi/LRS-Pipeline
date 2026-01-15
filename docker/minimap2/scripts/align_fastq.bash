#!/bin/bash
FASTQ=${FASTQS[$((LSB_JOBINDEX - 1))]}

HEAD=$(zcat ${FASTQ} | head -n1)
HEAD_CHECK="${HEAD//[^:]}"
if [[ ${#HEAD_CHECK} -eq 4 ]]; then
FLOWCELL=$(zcat ${FASTQ} | head -n1 | cut -d: -f1 | cut -d '@' -f2)
LANE=$(zcat ${FASTQ} | head -n1 | cut -d: -f2)
FLOWLANE="${FLOWCELL}.${LANE}"
elif [[ ${#HEAD_CHECK} -gt 4 ]]; then
FLOWCELL=$(zcat ${FASTQ} | head -n1 | cut -d: -f3)
LANE=$(zcat ${FASTQ} | head -n1 | cut -d: -f4)
FLOWLANE="${FLOWCELL}.${LANE}"
else
FLOWLANE=$(echo ${FASTQ##*/} | rev | cut -d_ -f2- | rev)
fi
echo "@RG\tID:${FLOWLANE}\tPL:illumina\tPU:${FLOWLANE}.${BARCODE}\tLB:${BARCODE}\tSM:${SM}\tDS:${FULLSMID}" > ${OUTDIR}/${FULLSMID}.${FLOWLANE}.rgfile

/opt/conda/bin/minimap2 \
    -a ${REF_FASTA}.mmi \
    $FASTQ \
    | samtools sort -b -o ${FASTQ%.fastq.gz}.aln.srt.bam