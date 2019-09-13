workflow smartseq2 {

  call get_accessions { input: acc_list = "../SRR_Acc_List.txt" }

  scatter (acc in get_accessions.accessions) {
    call download_fastq {
      input: accession = acc, outdir = "/data/scratch/sturm/test_pipeline/wdl/fastq"
    }
    call run_rsem {
      input:
        accession = acc,
        outdir = "/data/scratch/sturm/test_pipeline/wdl/rsem",
        fastq = download_fastq.fastq
    }
  }
}

task get_accessions {
  File acc_list
  command {
    cat ${acc_list}
  }
  output {
    Array[String] accessions = read_lines(stdout())
  }
}


task download_fastq {
  String accession
  String outdir
  runtime { cpu: 1 }
  command {
    fastq-dump --outdir ${outdir} --gzip --skip-technical --readids \
      --read-filter pass --dumpbase --split-files --clip ${accession}
  }
  output {
    File fastq = "${outdir}/${accession}_pass_1.fastq.gz"
  }
}



task run_rsem {
  String fastq
  String accession
  String outdir
  runtime { cpu: 8 }
  command {
    rsem-calculate-expression -p 8 \
      --star --star-gzipped-read-file \
      --no-bam-output --append-names  --single-cell-prior \
      ${fastq} \
      /home/sturm/scratch/pipeline_test/rsem/ref_hg38_ensemble \
      ${outdir}/${accession}
  }
  output {
    File rsem_genes = "${outdir}/${accession}.genes.results"
    File rsem_isoforms = "${outdir}/${accession}.isoforms.results"
  }
}
