process ALIGNMENT {
    tag "sample_id"
    conda "${moduleDir}/env.yml"
    label 'process_high_cpu'

    input:
    tuple val(meta), path(fastq_1), path(fastq_2), val(genome_name), path(indexed_genome)

    output:
    tuple val(meta), path("${meta.id}.sam"), path("${meta.id}.txt")

    script:
    """
    bowtie2 -p 12 -x "${indexed_genome}/${indexed_genome}" -1 ${fastq_1} -2 ${fastq_2} -S ${meta.id}.sam 2> ${meta.id}.txt
    """
}