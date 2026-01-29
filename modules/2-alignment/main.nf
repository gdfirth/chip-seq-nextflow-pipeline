process ALIGNMENT {
    tag "sample_id"
    conda "${moduleDir}/env.yml"

    input:
    tuple val(meta), path(fastq_1), path(fastq_2), val(genome_name), path(indexed_genome)

    script:
    """
    bowtie2 -x "${indexed_genome}/${indexed_genome}" -1 ${fastq_1} -2 ${fastq_2} -S ${meta.id}.sam 2> ${meta.id}.txt
    """
}