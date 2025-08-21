# Copyright (c) 2025 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.


variable "tenancy_ocid" {}
variable "region" { description = "Your tenancy region" }
variable "user_ocid" { default = "" }
variable "fingerprint" { default = "" }
variable "private_key_path" { default = "" }
variable "private_key_password" { default = "" }


variable "compartments_dependency" {
  type    = any
  default = null
}
variable "subscription_dependency" {
  type    = any
  default = null
}
variable "network_dependency" {
  type    = any
  default = null
}
variable "default_compartment_id" {
  type    = any
  default = null
}
variable "default_defined_tags" { default = null }
variable "default_freeform_tags" { default = null }
variable "cloud_exadata_infrastructures" {
  type    = any
  default = null
}
variable "cloud_vm_clusters" {
  type    = any
  default = null
}
