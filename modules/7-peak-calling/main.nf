process PEAK_CALLING {
    tag "${meta.id}"
    conda "${moduleDir}/env.yml"
    label 'process_medium_mem'
    publishDir "${params.output ?: 'results'}/peaks", mode: 'copy', pattern: '*_peaks_sorted.narrowPeak'//, '*_peaks_count.txt'

    input:
    tuple val(meta), path(bam_sample), path(bam_control)

    output:
    tuple val(meta), path("${meta.id}_peaks_sorted.narrowPeak"), emit: peaks_ch
    path("${meta.id}_peaks_count.txt"), emit: peaks_count_ch

    script:
    """
    macs3 callpeak -t ${bam_sample} -c ${bam_control} -f BAM --nomodel --extsize 200 -g 2.67e7 -p 1e-3 -n ${meta.id}
    wc -l ${meta.id}_peaks.narrowPeak > ${meta.id}_peaks_count.txt

    sort -k8,8nr ${meta.id}_peaks.narrowPeak > ${meta.id}_peaks_sorted.narrowPeak
    """
}
