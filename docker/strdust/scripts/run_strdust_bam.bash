BAM=$1
BAMBASE=${BAM##*/}

STRdust-linux \
	-t 8 \
	--minlen 5 \
	--support 3 \
	--sample ${BAMBASE%%.*} \
	--unphased \
	${REF_FASTA} \
	${BAM} \
	| bgzip -c > ${BAM%.bam}.strdust.vcf.gz \
	&& tabix ${BAM%.bam}.strdust.vcf.gz
