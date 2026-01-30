process DEDUPLICATE {
    tag "${meta.id}"
    conda "${moduleDir}/env.yml"
    label 'process_high_mem'
    publishDir "results/deduplicated", mode: 'copy', pattern: '*_dedup_metrics.txt'

    input:
    tuple val(meta), path(bam_file)

    output:
    tuple val(meta), path("${meta.id}_deduplicated.bam")

    script:
    """
    picard MarkDuplicates REMOVE_DUPLICATES=TRUE I=${bam_file} O=${meta.id}_deduplicated.bam M=${meta.id}_dedup_metrics.txt 
    """
}