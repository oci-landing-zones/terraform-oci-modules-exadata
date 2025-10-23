# OCI Landing Zones Exadata Module Example - Vision

## Introduction
This example shows how to deploy Exadata resources in Orcale Cloud Infrastructure (OCI).

It deploys the following resources:
- Database Home in an exisitng VM cluster
  - Container Database-1
    - Pluggable Database-1
    - Pluggable Database-2
  - Container Database-2
    - Pluggable Database-3
    - Pluggable Database-4

See [input.auto.tfvars.template](./input.auto.tfvars) for resource configuration. 
See [Module's README.md](../../README.md) for overall attributes usage.

## Using this example
1. Rename *input.auto.tfvars.template* to *<project-name>.auto.tfvars*, where *<project-name>* is any name of choice. 
2. Within *\<project-name\>.auto.tfvars*, provide tenancy connectivity information and adjust the input variables marked with *<REPLACE-WITH-...>*.

   Follow [this guide](https://docs.oracle.com/en-us/iaas/Content/dev/terraform/tutorials/tf-provider.htm#prepare) to Gather Required Information.

3. In this folder, run the typical Terraform workflow:
```
terraform init
terraform plan -out plan.out
terraform apply plan.out
```