#!/usr/bin/env nextflow
nextflow.enable.dsl=2

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { GENOME_INDEXING   } from './modules/1-genome-indexing'
include { ALIGNMENT         } from './modules/2-alignment'
//include { SAMTOOLS        } from './modules/3-peak-calling.nf'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow {

    //
    // Create input channel from genomes with paired GFF
    //

    genome_ch = channel.of( tuple( 'TbruceiLister427', file(params.fasta) ) )

    indexed_genome_ch = GENOME_INDEXING( genome_ch )

    samples_ch = channel.fromPath(params.input)
    .splitCsv(header: true)
    .map { row ->
        def meta = [
            id: "${row.sample}_${row.replicate ?: '1'}",
            sample: row.sample,
            replicate: row.replicate,
            antibody: row.antibody,
            control: row.control,
            control_replicate: row.control_replicate
        ]
        tuple(meta, file(row.fastq_1), file(row.fastq_2))
    }


    samples_ch.combine(indexed_genome_ch).set { align_in_ch }


    samples_ch.view()
    ALIGNMENT( align_in_ch )

}