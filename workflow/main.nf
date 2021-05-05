#! /usr/bin/env nextflow

// Enable DSL2 syntax for Nextflow
nextflow.enable.dsl = 2

// Include default parameters for the workflow.
// Override them in the params.config located in the analyses directories.
params.project = ''
params.clusterOptions = ''
params.outdir = 'results'

params.samples = ''

params.multiqc_config = "$baseDir/configs/multiqc_conf.yaml"

// Mode of copying results from the work directory
// 'symlink' : Use for test data.
// 'copy'    : Use for full analysis data.
params.publish_mode = 'symlink' // values: 'symlink', 'copy'

// Print parameters to screen before running workflow.
log.info("""
NBIS support <id>

 <Workflow title>
 ===================================

 Runtime parameters
     Project allocation          : ${params.project}
     Additional clusterOptions   : ${params.clusterOptions}
     Results folder              : ${params.outdir}

 Workflow parameters
     Sample Data paths           : ${params.samples}

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
    publishDir "${params.outdir}/01_FastQC", mode: params.publish_mode,

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

    publishDir "${params.outdir}/02_Fastp_Trimming", mode: params.publish_mode,

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

    publishDir "${params.outdir}", mode: params.publish_mode,

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
