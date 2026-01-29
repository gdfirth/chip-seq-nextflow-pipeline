process FILTERING {
    tag "sample_id"
    conda "${moduleDir}/env.yml"
    label 'process_medium_cpu'

    input:
    tuple val(meta), path(sam_file), path("alignment_stats.txt")

    output:
    tuple val(meta), path("${meta.id}_filtered.bam")

    script:
    """
    samtools view -F 2308 -b -q 10 ${sam_file} > ${meta.id}_filtered.bam
    """
}