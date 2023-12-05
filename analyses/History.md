# History

This history communicates the strategy followed to obtain the end results.
It is useful for longer projects to describe how and why certain analyses
were performed, and which analyses lead to what.

## Overview

A mermaid flowchart diagram can visually describe how folders relate each other.

An example chart for a longer project:
```mermaid
flowchart TD
  gatherdata[ 01_data_gather ]:::green --> cleandata[ 02_clean_data ]:::green
  cleandata --> analyse01[ 03_data_analysis_method_01 ]:::green
  cleandata --> analyse02[ 04_data_analysis_method_02 ]:::red
  analyse01 --> report[ 05_quarto_report ]:::green
  classDef red stroke:#f00
  classDef green stroke:#0f0
```
