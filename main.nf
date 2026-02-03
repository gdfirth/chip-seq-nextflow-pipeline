#!/usr/bin/env nextflow
nextflow.enable.dsl=2

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { GENOME_INDEXING   } from './modules/1-genome-indexing'
include { ALIGNMENT         } from './modules/2-alignment'
include { FILTERING         } from './modules/3-filtering'
include { SORTING           } from './modules/4-sorting'
include { DEDUPLICATE       } from './modules/5-deduplicate'
include { INDEXING          } from './modules/6-indexing'

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


    //samples_ch.view()
    align = ALIGNMENT( align_in_ch )
    aligned_ch = align.sam_ch


    filtered_ch = FILTERING( aligned_ch )

    sorted_ch = SORTING( filtered_ch )

    dedup_ch = DEDUPLICATE( sorted_ch )

    indexed_ch = INDEXING( dedup_ch )

    peak_input_ch = indexed_ch.map { item ->
        def meta = item[0]
        def bam_path = item[1]

        def is_control = meta.control == ""

        meta.is_control = is_control

        tuple( meta, bam_path )
    }

    peak_input_ch.view()

    peak_input_ch.filter{ item ->
        def meta = item[0]
        return !meta.is_control
    } .set { peak_input_samples_ch }
    
    peak_input_ch.filter{ item ->
        def meta = item[0]
        return meta.is_control
    } .set { peak_input_controls_ch }
    
    peak_input_controls_ch.view()
    peak_input_samples_ch.view()

}