process GENOME_INDEXING {
    tag "${genome_id}"
    conda "${moduleDir}/env.yml"

    input:
    tuple val(genome_id), path(fasta)

    output:
    tuple val(genome_id), path("Indexed_${genome_id}")

    script:
    """
    bowtie2-build ${fasta} "Indexed_${genome_id}"
    mkdir Indexed_${genome_id}
    mv Indexed_${genome_id}*.bt2 Indexed_${genome_id}/
    """
}