#!/bin/bash
## Set up variables for specific users. These should be all that's needed to change user
export COMPUTE_USER=fernandezv
export SCRATCH_USER=cruchagac
export STORAGE_USER=cruchagac
export REF_DIR="/storage1/fs1/cruchagac/Active/matthew.j/c1in/LRS/REF"

## Touch the references so that compute1 doesn't remove them
find $REF_DIR -true -exec touch '{}' \;

## 0. Set up for job submission 
# 0.2 Priorities are set to handle bounded-buffer issues
PRIORITY_ALIGN=60


# 0.3 Used to find other files needed in repository
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# 0.4 Define and create job groups
JOB_GROUP="/${USER}/compute-${COMPUTE_USER}"
JOB_GROUP_ALIGN="/${USER}/compute-${COMPUTE_USER}/align"
[[ -z "$(bjgroup | grep $JOB_GROUP)" ]] && bgadd -L 300 ${JOB_GROUP}
[[ -z "$(bjgroup | grep $JOB_GROUP_ALIGN)" ]] && bgadd -L 20 ${JOB_GROUP_ALIGN}

## Begin Job submission
FULLSMID=$1
INT=$2

export FULLSMID=$FULLSMID
export INDIR=/storage1/fs1/${STORAGE_USER}/Active/${USER}/c1in/${FULLSMID}

export LSF_DOCKER_VOLUMES="/storage1/fs1/${STORAGE_USER}:/storage1/fs1/${STORAGE_USER} \
/scratch1/fs1/${SCRATCH_USER}:/scratch1/fs1/${SCRATCH_USER} \
/storage1/fs1/${STORAGE_USER}/Active/${USER}/c1in/LRS/REF:/ref \
$HOME:$HOME"

export REF_FASTA=${REF_DIR}/GCA_009914755.4_T2T-CHM13v2.0_genomic.chr.fna

JOBNAME="ngi-${USER}"
LOGNAME="/scratch1/fs1/${SCRATCH_USER}/${USER}/c1out/logs/LRS/rescue"

bsub -g ${JOB_GROUP_ALIGN} \
    -J ${JOBNAME}-align-rescue \
    -n 1 \
    -Ne \
    -sp ${PRIORITY_ALIGN} \
    -o ${LOGNAME}.align.%J.out \
    -R 'rusage[mem=20GB]' \
    -G compute-${COMPUTE_USER} \
    -q general \
    -a 'docker(mjohnsonngi/minimap2:1.0)' bash /scripts/align_fastq_rescue.bash $INT
