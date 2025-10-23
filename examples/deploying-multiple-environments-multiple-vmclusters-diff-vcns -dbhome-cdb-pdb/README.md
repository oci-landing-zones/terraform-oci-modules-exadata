# OCI Landing Zones Exadata Module Example - Vision

## Introduction
This example shows how to deploy Exadata resources in Orcale Cloud Infrastructure (OCI).

It deploys the following resources:
- one Exadata Infrastructure
  - VM Cluster-1 in VCN-1
    - DB Home-1 
      - Container Database-1
        - Pluggable Database-1
        - Pluggable Database-2
      - Container Database-2
        - Pluggable Database-3
        - Pluggable Database-4
    - DB Home-2
      - Container Database-3
        - Pluggable Database-5
        - Pluggable Database-6
      - Container Database-4
        - Pluggable Database-7
        - Pluggable Database-8
  - VM Cluster-2 in VCN-2

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