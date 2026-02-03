#!/bin/bash
if [[ -z $CUDA_VISIBLE_DEVICES]]; then exit 66

for VAR in $(printenv | grep CUDA_VISIBLE_DEVICES); do
export ${VAR/CUDA/NVIDIA}
done

mkdir -p /scratch1/fs1/cruchagac/${USER}/c1in/${FULLSMID}
cat ${INDIR}/*.fastq.gz > /scratch1/fs1/cruchagac/${USER}/c1in/${FULLSMID}/${FULLSMID}.fastq.gz

/usr/local/parabricks/pbrun minimap2 \
    --ref ${REF_FASTA} \
    --index ${REF_FASTA}.mmi \
    --preset map-ont \
    --read-group-sm ${FULLSMID} \
    --tmp-dir /tmp \
    --low-memory \
    --in-fq /scratch1/fs1/cruchagac/${USER}/c1in/${FULLSMID}/${FULLSMID}.fastq.gz \
    --out-bam ${OUTDIR}/${FULLSMID}.merged.aln.srt.bam \
    --num-gpus 1 \
&& rm -R /scratch1/fs1/cruchagac/${USER}/c1in/${FULLSMID}