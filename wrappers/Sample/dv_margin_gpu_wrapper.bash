#!/bin/bash
## Set up variables for specific users. These should be all that's needed to change user
export COMPUTE_USER=fernandezv
export SCRATCH_USER=cruchagac
export STORAGE_USER=cruchagac
export REF_DIR="/storage1/fs1/cruchagac/Active/matthew.j/c1in/LRS/REF"

## Touch the references so that compute1 doesn't remove them
find $REF_DIR -true -exec touch '{}' \;

## 0. Set up for job submission 
# 0.1 Make expected directories in case they are missing
[ ! -d /scratch1/fs1/${SCRATCH_USER}/${USER} ] && mkdir /scratch1/fs1/${SCRATCH_USER}/${USER}
[ ! -d /scratch1/fs1/${SCRATCH_USER}/${USER}/c1out ] && mkdir /scratch1/fs1/${SCRATCH_USER}/${USER}/c1out
[ ! -d /storage1/fs1/${STORAGE_USER}/Active/${USER}/c1out ] && mkdir /storage1/fs1/${STORAGE_USER}/Active/${USER}/c1out
[ ! -d /scratch1/fs1/${SCRATCH_USER}/${USER}/c1out/logs ] && mkdir /scratch1/fs1/${SCRATCH_USER}/${USER}/c1out/logs

# 0.2 Priorities are set to handle bounded-buffer issues
PRIORITY_ALIGN=60
PRIORITY_DV=65
PRIORITY_MARGIN=70
PRIORITY_SNIF=80
PRIORITY_QC=50

# 0.3 Used to find other files needed in repository
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# 0.4 Define and create job groups
JOB_GROUP="/${USER}/compute-${COMPUTE_USER}"
JOB_GROUP_ALIGN="/${USER}/compute-${COMPUTE_USER}/align"
JOB_GROUP_QC="/${USER}/compute-${COMPUTE_USER}/qc"
[[ -z "$(bjgroup | grep $JOB_GROUP)" ]] && bgadd -L 300 ${JOB_GROUP}
[[ -z "$(bjgroup | grep $JOB_GROUP_ALIGN)" ]] && bgadd -L 20 ${JOB_GROUP_ALIGN}
[[ -z "$(bjgroup | grep $JOB_GROUP_QC)" ]] && bgadd -L 20 ${JOB_GROUP_QC}

## Begin Job submission loop
# This checks if the submission was a workfile or a direct submission of a sample and adds them to an array
export FULLSMID=$1

export INDIR=/storage1/fs1/${STORAGE_USER}/Active/${USER}/c1in/${FULLSMID}
export OUTDIR=/storage1/fs1/${STORAGE_USER}/Active/${USER}/c1out/${FULLSMID}
[ ! -d $OUTDIR ] && mkdir $OUTDIR
BAM="${OUTDIR}/${FULLSMID}.aln.srt.bam"
export LSF_DOCKER_VOLUMES="/storage1/fs1/${STORAGE_USER}:/storage1/fs1/${STORAGE_USER} \
/scratch1/fs1/${SCRATCH_USER}:/scratch1/fs1/${SCRATCH_USER} \
/storage1/fs1/${STORAGE_USER}/Active/${USER}/c1in/LRS/REF:/ref \
$HOME:$HOME"

export REF_FASTA=${REF_DIR}/GCA_009914755.4_T2T-CHM13v2.0_genomic.chr.fna

JOBNAME="ngi-${USER}-${FULLSMID}"
LOGNAME="/scratch1/fs1/${SCRATCH_USER}/${USER}/c1out/logs/LRS/${FULLSMID}"

bsub -g ${JOB_GROUP}/gpu \
    -J ${JOBNAME}-deepvariant-gpu \
    -n 8 \
    -Ne \
    -sp ${PRIORITY_DV} \
    -o ${LOGNAME}.deepvariant.%J.out \
    -R 'select[gpuhost && mem>180GB] rusage[mem=180GB] span[hosts=1]' \
    -gpu "num=1:gmem=12GB:j_exclusive=yes" \
    -G compute-cruchagac \
    -q general \
    -a 'docker(mjohnsonngi/deepvariant_gpu:1.0)' bash /scripts/run_deepvariant_gpu.bash $BAM

bsub -g ${JOB_GROUP} \
    -J ${JOBNAME}-margin \
    -w "done(\"${JOBNAME}-deepvariant-gpu\")" \
    -n 8 \
    -Ne \
    -sp ${PRIORITY_MARGIN} \
    -o ${LOGNAME}.margin.%J.out \
    -R 'rusage[mem=20GB]' \
    -G compute-${COMPUTE_USER} \
    -q general \
    -a 'docker(mjohnsonngi/margin:1.0)' bash /scripts/run_margin.bash $BAM ${BAM%.*}.vcf.gz
