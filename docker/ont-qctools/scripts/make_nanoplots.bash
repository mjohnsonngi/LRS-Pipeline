BAM=$1
BAMBASE=${BAM##*/}
mkdir ${BAM%/*}/${BAMBASE%%.*}_reports/
NanoPlot \
    --bam $BAM \
    --outdir ${BAM%/*}/${BAMBASE%%.*}_reports/ \
    --N50 \
    --title ${BAMBASE} \
    --prefix ${BAMBASE%%.*}