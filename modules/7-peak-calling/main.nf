process PEAK_CALLING {
    tag "${meta.id}"
    conda "${moduleDir}/env.yml"
    publishDir "results/peaks", mode: 'copy', pattern: '*_peaks.narrowPeak', '*_peaks_count.txt'

    input:
    tuple val(meta), path(bam_sample), path(bam_control)

    output:
    tuple val(meta), path("${meta.id}_peaks.narrowPeak"), emit: peaks_ch
    path("${meta.id}_peaks_count.txt"), emit: peaks_count_ch

    script:
    """
    macs2 callpeak -t ${bam_sample} -c ${bam_control} -g 2.67e7 --nomodel --extsize 200 --qvalue 0.01 --format BAM -n ${meta.id}_peaks.narrowPeak
    wc -l ${meta.id}_peaks.narrowPeak > ${meta.id}_peaks_count.txt
    """
}