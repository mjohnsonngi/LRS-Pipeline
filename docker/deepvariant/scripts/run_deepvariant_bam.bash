BAM=$1
BAMBASE=${BAM##*/}

/opt/deepvariant/bin/run_deepvariant \
	--model_type "ONT_R104" \
	--ref $REF_FASTA \
	--reads $BAM \
	--sample_name ${BAMBASE%%.*} \
	--output_vcf ${BAM%.*}.vcf.gz \
	--output_gvcf ${BAM%.*}.g.vcf.gz \
	--num_shards 16
	