process INDEXING {  
    tag "${meta.id}"
    conda "${moduleDir}/env.yml"
    label 'process_medium_cpu'

    input:
    tuple val(meta), path(bam)

    output:
    tuple val(meta), path("${meta.id}.indexed.bam")

    script:
    """
    samtools index -@ 6 ${bam} ${meta.id}.indexed.bam
    """
}