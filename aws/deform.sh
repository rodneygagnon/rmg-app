#!/bin/bash -x
#
# De-provision AWS resources

#set -e

source config.sh

cd ./terraform

terraform destroy -auto-approve -var default_region="${aws_region}" -var infra_prj="${aws_project}" -var infra_env="${aws_environment}"