#!/bin/bash -x
#
# Provision AWS resources

#set -e

source config.sh

cd ./terraform

terraform init

terraform plan -var default_region="${aws_region}" -var infra_prj="${aws_project}" -var infra_env="${aws_environment}" -out terraform.tfplan 

terraform apply -auto-approve -var default_region="${aws_region}" -var infra_prj="${aws_project}" -var infra_env="${aws_environment}"