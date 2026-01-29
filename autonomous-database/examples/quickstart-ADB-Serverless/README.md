# OCI Landing Zones Autonomous Database Example - Autonomous Database Serverless Quickstart

## Introduction
This is a quick start example to deploy an Autonomous Database Serverless with an existing Core Landing Zone deployment.

## Prerequisites
The following resources are deployed by the Core Landing Zone:
1. *\<service-label\>-database-kms-dynamic-group*
2. *\<service-label\>-database-dynamic-group-policy*
3. *\<service-label\>-vault*

The following resources need to be manually configured:
1. A KMS key in *\<service-label\>-vault*, in the *\<service-label\>-database-cmp* compartment.

This example deploys the following resources:
1. An Autonomous Database Serverless instance.

## Configuration and Usage
See [input.auto.tfvars.template](./input.auto.tfvars.template) for resource configuration. 
See [Module's README.md](../../README.md) for overall attribute usage.

## Using this example
1. Rename *input.auto.tfvars.template* to *\<project-name\>.auto.tfvars*. 
2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information and adjust the input variables marked with *<REPLACE-WITH-...>*.

   Follow [this guide](https://docs.oracle.com/en-us/iaas/Content/dev/terraform/tutorials/tf-provider.htm#prepare) to gather required information.

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```