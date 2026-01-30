process ALIGNMENT {
    tag "${meta.id}"
    conda "${moduleDir}/env.yml"
    label 'process_high_cpu'
    publishDir "results/alignmentlogs", mode: 'copy', pattern: '*_alignment_stats.txt'

    input:
    tuple val(meta), path(fastq_1), path(fastq_2), val(genome_name), path(indexed_genome)

    output:
    tuple val(meta), path("${meta.id}.sam"), emit: sam_ch
    path("${meta.id}_alignment_stats.txt"), emit: txt_ch

    script:
    """
    bowtie2 -p 12 --rg-id ${meta.id} --rg SM:${meta.id} --rg LB:lib1 --rg PL:ILLUMINA -x "${indexed_genome}/${indexed_genome}" -1 ${fastq_1} -2 ${fastq_2} -S ${meta.id}.sam 2> ${meta.id}_alignment_stats.txt
    """
}