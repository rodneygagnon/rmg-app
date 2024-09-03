#!/bin/bash -x
#
# Deploy container to EKS cluster

#set -e

source config.sh

image_source=${aws_project}-${aws_environment}-repo
image_target=${aws_account_id}.dkr.ecr.${aws_region}.amazonaws.com/${image_source}

deployment_yaml=${aws_project}-${aws_environment}-deployment.yaml

cd kubernetes

aws --region ${aws_region} eks update-kubeconfig --name ${aws_project}-${aws_environment}-eks-cluster

# Replace placeholders strings
sed -e 's,PRJ,'$aws_project',g' -e 's,ENV,'$aws_environment',g' -e 's,ECR_IMAGE,'$image_target',g' < manifest.yaml > $deployment_yaml

# create namespace
kubectl create namespace ${aws_project}-${aws_environment} || true

# create registry secret
kubectl create secret docker-registry regcred \
    --docker-server=${aws_account_id}.dkr.ecr.${aws_region}.amazonaws.com \
    --docker-username=AWS \
    --docker-password="$(aws ecr get-login-password --region ${aws_region})" \
    --namespace=${aws_project}-${aws_environment} || true

# create deployment
kubectl apply -f $deployment_yaml