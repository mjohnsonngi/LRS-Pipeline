BAM=$1
BAMBASE=${BAM##*/}

sniffles \
	-i ${BAM} \
	-v ${BAM%.bam}.sniffles.vcf \
	--snf ${BAM%.bam}.sniffles.snf \
	-t 8 \
	--minsvlen 25 \
&& bgzip ${BAM%.bam}.sniffles.vcf \
&& tabix ${BAM%.bam}.sniffles.vcf.gz
