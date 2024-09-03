#!/usr/bin/env bash
aws_account_id="`aws sts get-caller-identity --query "Account" --output text`"
aws_region="us-west-1"

aws_project="rmg"
aws_environment="dev"