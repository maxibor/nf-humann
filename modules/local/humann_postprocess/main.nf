process HUMANN_POSTPROCESS {
    tag "$meta.id"
    label 'process_medium'

    conda (params.enable_conda ? 'bioconda::humann=3.0.1' : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/humann:3.0.1--pyh5e36f6f_0' :
        'quay.io/biocontainers/humann:3.0.1--pyh5e36f6f_0' }"

    output:

    tuple val(meta), path('*.log')                , emit: log
    path "versions.yml"                           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    // Added soft-links to original fastqs for consistent naming in MultiQC
    def prefix = task.ext.prefix ?: "${meta.id}"
    """

    humann_join_tables \\
        -i . \\
        -o hmp_subset_genefamilies.tsv \\
        --file_name genefamilies \\
    
    humann_renorm_table \\
        -i genefamilies.tsv \\
        -o genefamilies-cpm.tsv \\
        --taxonomic-profile
        --units cpm

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        humann: \$(humann --version  2>&1 | cut -f 2 -d 'v')
    END_VERSIONS
    """
}
