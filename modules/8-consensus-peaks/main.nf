
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
    bedtools intersect -wo -a ${peaks1} -b ${peaks2} > ${meta1.id}_${meta2.id}_consensus.bed
    cut -f 1-10 ${meta1.id}_${meta2.id}_consensus.bed > ${meta1.id}_${meta2.id}_temp.bed
    cut -f 11-20 ${meta1.id}_${meta2.id}_consensus.bed >> ${meta1.id}_${meta2.id}_temp.bed

    sort -k1,1 -k2,2n ${meta1.id}_${meta2.id}_temp.bed > ${meta1.id}_${meta2.id}_temp_sorted.bed

    bedtools merge -i ${meta1.id}_${meta2.id}_temp_sorted.bed > ${meta1.id}_${meta2.id}_consensus.bed
    
    bedtools intersect -wo -a ${meta1.id}_${meta2.id}_consensus.bed -b ${peaks3} > ${meta1.id}_${meta2.id}_${meta3.id}_temp.bed
    cut -f 1-10 ${meta1.id}_${meta2.id}_${meta3.id}_temp.bed > ${meta1.id}_${meta2.id}_${meta3.id}_consensus_peaks.bed
    cut -f 11-20 ${meta1.id}_${meta2.id}_${meta3.id}_temp.bed >> ${meta1.id}_${meta2.id}_${meta3.id}_consensus_peaks.bed

    sort -k1,1 -k2,2n ${meta1.id}_${meta2.id}_${meta3.id}_consensus_peaks.bed > ${meta1.id}_${meta2.id}_${meta3.id}_consensus_peaks_sorted.bed

    bedtools merge -i ${meta1.id}_${meta2.id}_${meta3.id}_consensus_peaks_sorted.bed > ${meta1.id}_${meta2.id}_${meta3.id}_consensus_peaks.bed

    """
}