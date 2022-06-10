#!/usr/bin/env nextflow
nextflow.enable.dsl = 2


include { FASTP }  from './modules/nf-core/modules/fastp/main'
include { HUMANN } from './modules/local/humann/main'
include { METAPHLAN3 } from './modules/nf-core/modules/metaphlan3/main'


Channel
    .fromFilePairs(params.input, size: -1)
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
    .first()
    .set {nucleotide_db }
Channel
    .fromPath(params.protein_db)
    .first()
    .set{ protein_db }
Channel
    .fromPath(params.metaphlan_db)
    .first()
    .set{ metaphlan_db }




workflow  {
    FASTP(raw_reads_ch, false, true)

    METAPHLAN3(FASTP.out.reads.mix(FASTP.out.reads_merged), metaphlan_db)

    FASTP.out.reads.mix(FASTP.out.reads_merged)
        .join(METAPHLAN3.out.profile, by: 0)
        .set {humann_input_ch }

    HUMANN(humann_input_ch, nucleotide_db, protein_db)
}