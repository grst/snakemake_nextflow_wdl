#!/usr/bin/env nextflow

OUT_DIR = "/data/scratch/sturm/piepline_test/nextflow/"

Channel.fromPath('../SRR_Acc_List.txt')
       .splitText()
       .set{ accessions_ch }

/**
 * Dowload fastq files
 */
process download_fastq {
  conda "envs/fastq.yml"
  publishDir OUT_DIR + "fastq"

  input:
  val acc from accessions_ch

  output:
  set acc, file('*_pass_1.fastq.gz') into fastqs


  """
  fastq-dump \
  --gzip --skip-technical --readids \
  --read-filter pass --dumpbase --split-files --clip $acc
  """
}

/**
 * Align and quantify using RSEM+STAR
 */
process run_rsem {
  conda "envs/mapping.yml"
  publishDir OUT_DIR + "rsem"

  cpus 8

  input:
  set acc, file(fastq_file) from fastqs

  output:
  file('*.genes.results') into rsem_genes
  file('*.isoforms.results') into rsem_isoforms

  """
   rsem-calculate-expression -p 8 \
     --star --star-gzipped-read-file \
     --no-bam-output --append-names  --single-cell-prior \
     $fastq_file \
     /home/sturm/scratch/pipeline_test/rsem/ref_hg38_ensemble \
     $acc

  """
}
