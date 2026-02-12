
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
    bedtools intersect -u -a ${peaks1} -b ${peaks2} > ${meta1.id}_in_${meta2.id}_consensus_peaks.bed
    bedtools intersect -u -a ${peaks1} -b ${peaks3} > ${meta1.id}_in_${meta3.id}_consensus_peaks.bed
    bedtools intersect -u -a ${peaks2} -b ${peaks3} > ${meta2.id}_in_${meta3.id}_consensus_peaks.bed
    bedtools intersect -u -b ${peaks1} -a ${peaks2} > ${meta2.id}_in_${meta1.id}_consensus_peaks.bed
    bedtools intersect -u -b ${peaks1} -a ${peaks3} > ${meta3.id}_in_${meta1.id}_consensus_peaks.bed
    bedtools intersect -u -b ${peaks2} -a ${peaks3} > ${meta3.id}_in_${meta2.id}_consensus_peaks.bed
    


    bedtools intersect -u -a ${meta1.id}_in_${meta2.id}_consensus_peaks.bed -b ${meta1.id}_in_${meta3.id}_consensus_peaks.bed > ${meta1.id}_in_${meta2.id}_and_${meta3.id}_consensus_peaks.bed
    bedtools intersect -u -a ${meta2.id}_in_${meta1.id}_consensus_peaks.bed -b ${meta2.id}_in_${meta3.id}_consensus_peaks.bed > ${meta2.id}_in_${meta1.id}_and_${meta3.id}_consensus_peaks.bed
    bedtools intersect -u -a ${meta3.id}_in_${meta1.id}_consensus_peaks.bed -b ${meta3.id}_in_${meta2.id}_consensus_peaks.bed > ${meta3.id}_in_${meta1.id}_and_${meta2.id}_consensus_peaks.bed

    bedtools intersect -u -a ${meta1.id}_in_${meta2.id}_and_${meta3.id}_consensus_peaks.bed -b ${meta2.id}_in_${meta1.id}_and_${meta3.id}_consensus_peaks.bed -u > ${meta1.id}_${meta2.id}_consensus_peaks.bed
    bedtools intersect -u -a ${meta1.id}_${meta2.id}_consensus_peaks.bed -b ${meta3.id}_in_${meta1.id}_and_${meta2.id}_consensus_peaks.bed -u > ${meta1.id}_${meta2.id}_${meta3.id}_consensus_peaks.bed
    """
}