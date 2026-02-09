process PEAK_CALLING {
    tag "${meta.id}"
    conda "${moduleDir}/env.yml"
    label 'process_medium_mem'
    publishDir "${params.output ?: 'results'}/peaks", mode: 'copy', pattern: '*_peaks.narrowPeak'//, '*_peaks_count.txt'

    input:
    tuple val(meta), path(bam_sample), path(bam_control)

    output:
    tuple val(meta), path("${meta.id}_peaks.narrowPeak"), emit: peaks_ch
    path("${meta.id}_peaks_count.txt"), emit: peaks_count_ch

    script:
    """
    macs3 callpeak -t ${bam_sample} -c ${bam_control} --nomodel --extsize 200 -g 2.67e7 --qvalue 0.01 -n ${meta.id}
    wc -l ${meta.id}_peaks.narrowPeak > ${meta.id}_peaks_count.txt
    """
}
