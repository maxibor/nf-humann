process HUMANN_DOWNLOAD_DB {
    tag "$meta.id"
    label 'process_medium'

    conda (params.enable_conda ? 'bioconda::humann=3.0.1' : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/humann:3.0.1--pyh5e36f6f_0' :
        'quay.io/biocontainers/humann:3.0.1--pyh5e36f6f_0' }"

    input:
        val(nucleotidedb)
        val(proteindb)

    output:
        path("humann_nucleotide_db")  , emit: nucleotide_db
        path("humann_protein_db")  , emit: protein_db
    tuple val(meta), path('*.log')                , emit: log
    path "versions.yml"                           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    // Added soft-links to original fastqs for consistent naming in MultiQC
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    humann_databases \\
        --update-config yes \\
        --update-database chocophlan full $nucleotide_db
    
    humann_databases \\
        --update-config yes \\
        --update-database database_folders protein $protein_db

    

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        humann: \$(humann --version  2>&1 | cut -f 2 -d 'v')
    END_VERSIONS
    """
}
