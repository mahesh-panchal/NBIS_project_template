#! /usr/bin/env nextflow

// Default workflow parameters are provided in the file 'nextflow.config'.

// Include modules, i.e. process definitions
include { FASTQC  } from "$projectDir/modules/fastqc"
include { FASTP   } from "$projectDir/modules/fastp"
include { MULTIQC } from "$projectDir/modules/multiqc"

// The main workflow
workflow {

    main:
    // Print Workflow header
    log.info("""
    NBIS support <id>

    $workflow.manifest.name
    ===================================
    $workflow.manifest.description

    """)

    // Check a project allocation is given for running on Uppmax clusters.
    if( workflow.profile.tokenize(',').intersect([ "uppmax", "pdc_kth" ]) && !params.project ){
        error "Please provide a NAISS project number ( --project )!\n"
    }
    // Get data
    readpairs_ch = Channel.fromFilePairs( params.samples, checkIfExists: true )
        .ifEmpty { error "Cannot find reads from ${params.samples}!\n" }
        .filter { it != null }
        .map{ name, reads -> [ [ id: name, single_end: false ], reads ] } // reformat input to nf-core style, i.e. pass metadata using a Map

    // Analyses
    FASTQC ( readpairs_ch )
    FASTP (
        readpairs_ch,
        [],    // skip adapter fasta
        false, // don't save failed
        false, // don't save merged
    )

    // Report
    mqc_logs_ch = FASTQC.out.zip
        .mix(
            FASTP.out.log
        )
        .map{ it[1] }           // Remove metadata map
    MULTIQC (
        mqc_logs_ch,
        params.multiqc_config,  // standard config
        [],                     // extra config
        [],                     // custom logo
    )

}
