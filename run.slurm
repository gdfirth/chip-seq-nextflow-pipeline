#!/bin/bash
#SBATCH --job-name=chipseq_nextflow_pipeline
#SBATCH --output=slurm-nextflow.out
#SBATCH --error=slurm-nextflow.err
#SBATCH --time=120:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=16G

module load Nextflow/24.10.2
#module load Miniforge3/24.7.1-2
module load Miniconda3/23.10.0-1

#TODO Check whether I need to set these paths or whether conda.cacheDir in nextflow.config is sufficient
export CONDA_ENVS_PATH=/data/gpfs/projects/punim2267/gfirth/conda/envs
export CONDA_PKGS_DIRS=/data/gpfs/projects/punim2267/gfirth/conda/pkgs
export CONDA_REPODATA_DIR=/data/gpfs/projects/punim2267/gfirth/conda/repodata

nextflow run main.nf -resume
