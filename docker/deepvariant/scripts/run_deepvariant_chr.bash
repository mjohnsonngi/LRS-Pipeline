BAM=$1
CHR=$2
BAMBASE=${BAM##*/}

samtools view -@ 8 -b -o ${BAM%.*}_${CHR}.bam $BAM chr${CHR}
samtools index -@ 8 ${BAM%.*}_${CHR}.bam

/opt/deepvariant/bin/run_deepvariant \
	--model_type "ONT_R104" \
	--ref $REF_FASTA \
	--reads ${BAM%.*}_${CHR}.bam \
	--sample_name ${BAMBASE%%.*} \
	--output_vcf ${BAM%.*}_${CHR}.vcf.gz \
	--output_gvcf ${BAM%.*}_${CHR}.g.vcf.gz \
	--num_shards 8
	
rm ${BAM%.*}_${CHR}.bam
rm ${BAM%.*}_${CHR}.bam.bai