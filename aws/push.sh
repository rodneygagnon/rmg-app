#!/bin/bash -x
#
# Builds a Docker image and pushes to an AWS ECR repository

#set -e

source config.sh

image_source=${aws_project}-${aws_environment}-repo
image_target=${aws_account_id}.dkr.ecr.${aws_region}.amazonaws.com/${image_source}

image_tag="${1:-latest}" # Checks if argument exists, if not, use "latest"

# Login to AWS ECR
aws --region ${aws_region} ecr get-login-password | docker login --username AWS --password-stdin ${aws_account_id}.dkr.ecr.${aws_region}.amazonaws.com

cd ..

# Build the docker image
docker build -t ${image_source} .

# Tag and push the image
docker tag ${image_source}:${image_tag} ${image_target}:${image_tag}
docker push ${image_target}:${image_tag}
