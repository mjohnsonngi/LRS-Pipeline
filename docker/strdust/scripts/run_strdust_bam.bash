BAM=$1
BAMBASE=${BAM##*/}

STRdust-linux \
	-t 8 \
	--minlen 5 \
	--support 3 \
	--sample ${BAMBASE%%.*} \
	--unphased \
	-R /scripts/STRchive-disease-loci.T2T-chm13.longTR.bed \
	${REF_FASTA} \
	${BAM} \
	| bcftools sort -Oz -o ${BAM%.bam}.strdust.vcf.gz \
	&& tabix ${BAM%.bam}.strdust.vcf.gz
