#! /usr/bin/env nextflow

// Default workflow parameters are provided in the file 'nextflow.config'.
// Override them in the params.yml located in the analyses directories.

include { FASTQC } from './modules/nf-core/fastqc/main'

// Minimal example workflow shipped by the template - QCs the samples
// fetched by analyses/01_fetch-source-data/. Replace with a real
// workflow as the project's needs grow; see docs/advice/code.md.
workflow {

    main:
    log.info("""
    $workflow.manifest.name
    ===================================
    $workflow.manifest.description
    """)

    // Check a project allocation is given for clusters that need one.
    if( workflow.profile.tokenize(',').intersect([ "pelle", "bianca", "dardel", "arrhenius" ]) && !params.project ){
        error "Please provide a NAISS project number ( --project )!\n"
    }

    reads_ch = Channel.fromFilePairs( params.samples, checkIfExists: true )
        .map { name, reads -> [ [ id: name ], reads ] }

    FASTQC( reads_ch )

    publish:
    html = FASTQC.out.html
    zip  = FASTQC.out.zip
}

output {
    html {
        path "fastqc"
    }
    zip {
        path "fastqc"
    }
}
