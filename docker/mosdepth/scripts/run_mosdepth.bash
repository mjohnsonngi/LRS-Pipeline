BAM=$1
mosdepth \
	--no-per-base \
	--fasta $REF_FASTA \
	--fast-mode \
	--mapq 10 \
	--by 500 \
	${BAM%.*} \
	$BAM