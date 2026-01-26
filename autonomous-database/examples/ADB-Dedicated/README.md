# OCI Landing Zones Autonomous Database Example - Autonomous Database-Dedicated

## Introduction
This is an example of deploying an Autonomous Database on Dedicated Exadata Infrastructure (ADB-D).

Prerequisites that need to be manually configured:
1. An Autonomous Container Database (ACD) on your Dedicated Exadata Infrastructure

## Resources Deployed
This example deploys the following resources:
1. An Autonomous Database on Dedicated (ADB-D) instance within the specified Autonomous Container Database.

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