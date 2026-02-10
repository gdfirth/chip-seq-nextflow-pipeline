# chip-seq-nextflow-pipeline
Custom ChIP-Seq Pipeline built in Nextflow for the Monti Lab

Takes in 3 technical replicate samples and 1 control sample (`samplesheet.csv`). Workflow should be forked and slightly modified to handle differently numbered sets.


## Project structure (file locations)
- `main.nf`: top‑level Nextflow pipeline entry point.
- `nextflow.config`: Nextflow configuration for execution, resources, and profiles.
- `params.yml`: pipeline parameters (input paths, reference files, tool options).
- `samplesheet.csv`: input manifest.
- `run.slurm`: Slurm submission script for running the pipeline on HPC.
- `input/`: staging area for input data.
- `modules/`: pipeline modules, organized by step:
  - `1-genome-indexing/`
  - `2-alignment/`
  - `3-filtering/`
  - `4-sorting/`
  - `5-deduplicate/`
  - `6-indexing/`
  - `7-peak-calling/`
  - `8-consensus-peaks/`
- `clear.sh`: helper script for cleaning hard reset of cache (!!!!IRREVERSIBLE!!!!).
