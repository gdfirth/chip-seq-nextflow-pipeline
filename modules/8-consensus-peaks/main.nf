
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
    idr --samples ${peaks1} ${peaks2} ${peaks3} \
    --input-file-type narrowPeak \
    --rank p.value \
    --output-file ${meta1.id}_${meta2.id}_${meta3.id}_idr \
    --plot \
    --log-output-file ${meta1.id}_${meta2.id}_${meta3.id}.idr.log

    wc -l *_idr
    """
}