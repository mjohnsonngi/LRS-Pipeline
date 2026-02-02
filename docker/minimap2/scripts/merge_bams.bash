#!/bin/bash
samtools merge -c -o ${OUTDIR}/${FULLSMID}.merged.aln.srt.bam ${INDIR}/*.aln.srt.bam \
&& rm ${INDIR}/*.aln.srt.bam

samtools index ${OUTDIR}/${FULLSMID}.merged.aln.srt.bam