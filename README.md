# Simple comparison of Snakemake, Nextflow and Cromwell/WDL

I will implement very simple workflow (download FASTQ files and align them to a reference genome)
using all three platforms and compare.

## Criteria
* Support for conda envs
* Support for singularity
* User-friendlyness
* How easy to submit on cluster?

# Snakemake

* very good documentation
✓ conda ✓ singularity

## How to run on cluster:
```
snakemake --use-conda --cluster qsub --jobscript /path/to/wrapper_script.sh --jobs 32
```

* `--use-conda` is required to create an environment for each task from a corresponding yaml file
* `--cluster qsub` tells snakemake to submit jobs using qsub
* `--jobscript` points to a wrapper script for qsub containing configuration options
* `--jobs` max number of jobs submitted to the cluster in parallel. Snakemake takes care of resubmitting.
* `--profile` allows to configure system-wide profiles to run on the cluster.

The jobscript looks something like this:
```
#$ -cwd
#$ -V
#$ -e ./logs/
#$ -o ./logs/

```


# Nextflow
✓ conda ✓ singularity

* works with conda in principle, but currently not because of [#1195](https://github.com/nextflow-io/nextflow/issues/1195).

* very good documentation

## Differences to Snakemake

* has no 'dry-run' mode
* change executor only via config files (bad for testing)
* file-name-abstraction

## How to run on cluster

