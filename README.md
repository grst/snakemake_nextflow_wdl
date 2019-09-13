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

* published 2012, >500 citations.

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

* published 2017, 180 citations

* works with conda in principle, but currently not because of [#1195](https://github.com/nextflow-io/nextflow/issues/1195).

* very good documentation

## Differences to Snakemake

* has no 'dry-run' mode
* change executor only via config files (bad for testing)
* file-name-abstraction. That means: not all files are exposed to the user but stay in a hidden working directory (every job gets an own directory). Debugging is easy, as one can change to the job-directory and check what's going on. Result files can be explicitly exposed via `publishDir` directive.

## How to run on cluster

* via configuration file. Either global or local.
* local configuration file: put into project directory `nextflow.config`

Looks like this:

To run on cluster:
```
process {
  executor = 'sge'
  penv = 'smp'
    clusterOptions = { "-V -S /bin/bash " }
  }
```

To run locally:
```
executor {
  cpus = 10 /* max cpus on local machine */
}
```


# Cromwell/WDL
✗ conda ✓ singularity

* mediocre documentation for getting the user started, but it's ok.
* finishes all running tasks, even if a later task fails.
* no support for conda environments
