process FILTERING {
    tag "${meta.id}"
    conda "${moduleDir}/env.yml"
    label 'process_medium_cpu'

    input:
    tuple val(meta), path(sam_file)

    output:
    tuple val(meta), path("${meta.id}_filtered.bam")

    script:
    """
    samtools view -@ 6 -F 2308 -b -q 10 ${sam_file} > ${meta.id}_filtered.bam
    """
}