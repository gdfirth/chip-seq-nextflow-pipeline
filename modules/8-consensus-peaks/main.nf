
process CONSENSUS_PEAKS {
    tag "${meta1.id}_${meta2.id}_${meta3.id}"
    conda "${moduleDir}/env.yml"
    label 'process_low'
    publishDir "${params.output ?: 'results'}/consensus_peaks", mode: 'copy'

    input:
    tuple val(meta1), path(peaks1), val(meta2), path(peaks2), val(meta3), path(peaks3)

    output:
    path("${meta1.id}_${meta2.id}_${meta3.id}_consensus_peaks.bed"), emit: consensus_peaks_ch

    script:
    """
    bedtools intersect -a ${peaks1} -b ${peaks2} > ${meta1.id}_${meta2.id}_consensus_peaks.bed

    bedtools intersect -a ${meta1.id}_${meta2.id}_consensus_peaks.bed -b ${peaks3} > ${meta1.id}_${meta2.id}_${meta3.id}_consensus_peaks.bed
    """
}