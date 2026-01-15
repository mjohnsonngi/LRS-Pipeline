#!/bin/bash
BAM=$1
VCF=$2
margin phase \
    $BAM \
    $REF_FASTA \
    $VCF \
    /opt/margin/params/phase/allParams.haplotag.ont-r104q20.json \
    -t 8 \
    -o ${VCF%.*.*} \
    -M

bgzip ${VCF%.*.*}.phased.vcf
