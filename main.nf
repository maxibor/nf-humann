#!/usr/bin/env nextflow
nextflow.enable.dsl = 2


include { FASTP }  from './modules/nf-core/modules/fastp/main'
include { HUMANN } from './modules/local/humann/main'


Channel
    .fromFilePairs(params.input)
    .map {
            meta, fastq ->
            def fmeta = [:]
            // Set meta.id
            fmeta.id = meta
            // Set meta.single_end
            if (fastq.size() == 1) {
                fmeta.single_end = true
            } else {
                fmeta.single_end = false
            }
            [ fmeta, fastq ]
        }
    .set { raw_reads_ch }

Channel
    .fromPath(params.nucleotide_db)
    .set{nucleotide_db}
Channel
    .fromPath(params.protein_db)
    .set{protein_db}


workflow  {
    FASTP(raw_reads_ch, false, true)
    HUMANN(FASTP.out.reads_merged, nucleotide_db, protein_db)
}