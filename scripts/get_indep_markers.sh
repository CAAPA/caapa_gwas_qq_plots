#!/bin/bash

mkdir ../data
mkdir ../data/input

#Usage
if [ "$#" -eq  "0" ]
then
    echo "Usage: ${0##*/} <chr_nr>"
    exit
fi

#Set parameters
chr=$1
vcf_name=/gpfs/barnes_share/dcl01_data/CAAPA_jhuGRAAD_BDOS_032416/AA_vcf_merge/AA_chr${chr}_dose_vcf_bcftools.vcf
geno_name=$SCRATCH/genos_chr${chr}
prune_name=$SCRATCH/prune_chr${chr}

#Convert imputed values to genotype calls
plink --vcf ${vcf_name} --vcf-min-gp 0.8 --make-bed --out $geno_name

#Get list of markers that are in LD
#See http://pngu.mgh.harvard.edu/~purcell/plink/summary.shtml#prune for interpration of parameters
plink --bfile $geno_name --indep 100 5 1.05 --out $prune_name

#Cleanup
mv ${prune_name}.prune.in ../data/input
rm ${geno_name}.*
