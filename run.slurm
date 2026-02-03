#!/bin/bash
#SBATCH --job-name=chipseq_nextflow_pipeline
#SBATCH --output=slurm-nextflow.out
#SBATCH --error=slurm-nextflow.err
#SBATCH --time=120:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=16G

module load Nextflow/24.10.2
module load Miniforge3/24.7.1-2

export CONDA_NO_PLUGINS=true
export CONDA_ENVS_PATH=$HOME/.conda/envs
export CONDA_PKGS_DIRS=$HOME/.conda/pkgs
export CONDA_REPODATA_DIR=$HOME/.conda/repodata
nextflow run main.nf -resume
