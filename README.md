# Simple comparison of Snakemake, Nextflow and Cromwell/WDL

I will implement very simple workflow (download FASTQ files and align them to a reference genome) 
using all three platforms and compare. 

## Criteria
* Support for conda envs
* Support for singularity
* User-friendlyness
* How easy to submit on cluster? 

# Snakemake
✓ conda ✓ singularity

## How to run on cluster: 
```
snakemake --use-conda --cluster qsub --jobscript /path/to/wrapper_script.sh --jobs 32
```

* `--use-conda` is required to create an environment for each task from a corresponding yaml file
* `--cluster qsub` tells snakemake to submit jobs using qsub
* `--jobscript` points to a wrapper script for qsub containing configuration options
* `--jobs` max number of jobs submitted to the cluster in parallel. Snakemake takes care of resubmitting. 

The jobscript looks something like this: 
```
#$ -cwd
#$ -V
#$ -e ./logs/
#$ -o ./logs/

{exec_job}
```
