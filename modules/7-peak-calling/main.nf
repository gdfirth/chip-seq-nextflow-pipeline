process PEAK_CALLING {
    tag "${sample_id}"

    input:
    tuple val(sample_id), path(bam_index)

    output:
    tuple val(sample_id), path("${sample_id}_peaks.narrowPeak")

    script:
    """
    macs2 callpeak -t ${bam_index} -c ${bam_index} -g 2.67e7 -- nomodel --extsize 200 --qvalue 0.01 -n ${sample_id}_peaks
    """
}