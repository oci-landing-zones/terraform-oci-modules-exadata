# Copyright (c) 2025 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "vision_exadata" {
  source                  = "../.."
  exadata_infrastructures = var.exadata_infrastructures
  compartments_dependency = var.compartments_dependency
  network_dependency      = var.network_dependency
  default_compartment_id  = var.default_compartment_id
  default_defined_tags    = var.default_defined_tags
  default_freeform_tags   = var.default_freeform_tags

}
