#!/bin/bash
#PBS -P nm03
#PBS -q normalsr
#PBS -l walltime=2:00:00
#PBS -l ncpus=1
#PBS -l mem=30GB
#PBS -l jobfs=10GB
#PBS -l wd
#PBS -N collate_test
#PBS -o collate_test.o
#PBS -e collate_test.e

module use /g/data/vk83/modules
module use /g/data/x77/ahg157/spack/1.1/release/modules/linux-rocky8-x86_64

module load access-om3/2025.08.003-tracers-from-file
module load model-tools/mppnccombine-fast
module load nco/5.0.5
module load fre-nctools/2024.05-1

# load payu itself — adjust to however you normally load it
module load payu


payu collate -i 1