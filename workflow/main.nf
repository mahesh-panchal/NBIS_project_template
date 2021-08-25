#! /usr/bin/env nextflow

// Enable DSL2 syntax for Nextflow
nextflow.enable.dsl = 2

// Default workflow parameters are provided in the file 'nextflow.config'.

// Print Workflow header
log.info("""
NBIS support <id>

 <Workflow title>
 ===================================

""")

// Check a project allocation is given for running on Uppmax clusters.
if(workflow.profile == "uppmax" && !params.project){
    exit 1, "Please provide a SNIC project number ( --project )!\n"
}

// The main workflow
workflow {

    main:
        // Get data
        Channel.fromPath(params.samples)
            .ifEmpty { exit 1, "Cannot find reads from ${params.samples}!\n" }
            .set { readpairs }

        // Analyses
        FASTQC(readpairs)
        FASTP(readpairs)

        // Report
        MULTIQC(
            params.multiqc_config,
            FASTQC.out.collect().ifEmpty([]),
            FASTP.out.logs.ifEmpty([])
            )

}

process FASTQC {

    // Publish directories are numbered to help understand processing order
    publishDir "${params.results}/01_FastQC", mode: params.publish_mode

    conda (params.enable_conda ? "bioconda::fastqc=0.11.9" : null)
    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
        container "https://depot.galaxyproject.org/singularity/fastqc:0.11.9--0"
    } else {
        container "quay.io/biocontainers/fastqc:0.11.9--0"
    }

    input:
    tuple val(sample), path(reads)

    output:
    path ("fastqc_${sample}_logs")

    script:
    """
    mkdir fastqc_${sample}_logs
    fastqc -t ${task.cpus} -o fastqc_${sample}_logs -f fastq -q ${reads}
    """

}

process FASTP {

    publishDir "${params.results}/02_Fastp_Trimming", mode: params.publish_mode

    conda (params.enable_conda ? 'bioconda::fastp=0.20.1' : null)
    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
        container 'https://depot.galaxyproject.org/singularity/fastp:0.20.1--h8b12597_0'
    } else {
        container 'quay.io/biocontainers/fastp:0.20.1--h8b12597_0'
    }

    input:
    tuple val(sample), path(reads)

    output:
    tuple val(sample), path("*fastp-trimmed_R{1,2}.fastq.gz"), emit: reads
    path "*_fastp.json", emit: logs

    script:
    """
    fastp -Q -L -w ${task.cpus} -i ${reads[0]} -I ${reads[1]} \\
        -o ${sample}_fastp-trimmed_R1.fastq.gz \\
        -O ${sample}_fastp-trimmed_R2.fastq.gz \\
        --json ${sample}_fastp.json
    """

}

process MULTIQC {

    publishDir "${params.results}", mode: params.publish_mode

    conda (params.enable_conda ? 'bioconda::multiqc=1.11' : null)
    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
        container "https://depot.galaxyproject.org/singularity/multiqc:1.11--pyhdfd78af_0"
    } else {
        container "quay.io/biocontainers/multiqc:1.11--pyhdfd78af_0"
    }

    input:
    path config
    path "fastqc/*"
    path "fastp/*"

    output:
    path "multiqc_report.html"

    script:
    """
    multiqc . -c ${config}
    """
}
