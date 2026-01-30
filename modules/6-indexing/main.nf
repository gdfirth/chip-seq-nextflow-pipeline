process INDEXING {  
    tag { "${meta.id}" }

    input:
    tuple val(meta), path(bam)

    output:
    tuple val(meta), path("${meta.id}.indexed.bam")

    script:
    """
    samtools index ${bam} ${meta.id}.indexed.bam
    """
    
}