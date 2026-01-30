process SORTING {
    tag "${meta.id}"
    conda "${moduleDir}/env.yml"
    label 'process_medium_cpu'

    input:
    tuple val(meta), path(bam_file)

    output:
    tuple val(meta), path("${meta.id}_sorted.bam")

    script:
    """
    samtools sort -@ 6 -m 1G -o ${meta.id}_sorted.bam -O 'bam' -T temp_${meta.id} ${bam_file}
    """
}