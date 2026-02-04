#!/bin/bash
BAM=$1
for VAR in $(printenv | grep CUDA_VISIBLE_DEVICES); do
export ${VAR/CUDA/NVIDIA}
done

/usr/local/parabricks/pbrun deepvariant \
    --ref ${REF_FASTA} \
    --in-bam ${BAM} \
    --out-variants ${BAM%.*}.vcf \
    --num-gpus 1 \
    --mode ont \
&& gzip ${BAM%.*}.vcf \
&& tabix ${BAM%.*}.vcf.gz