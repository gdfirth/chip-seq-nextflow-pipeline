process INDEXING {  
    tag "${meta.id}"
    conda "${moduleDir}/env.yml"
    label 'process_medium_cpu'

    input:
    tuple val(meta), path(bam)

    output:
    tuple val(meta), path("${bam}")

    script:
    """
    #ln -s ${bam} ${meta.id}.indexed.bam
    #samtools index -@ 6 ${meta.id}.indexed.bam
    samtools index -@ 6 ${bam}
    """
}
