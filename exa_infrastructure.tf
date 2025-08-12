# Copyright (c) 2025, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_availability_domains

# NOTE!!! Note that the order of the results returned can change if availability domains are added or removed; 
# therefore, do not create a dependency on the list order.
data "oci_identity_availability_domains" "ads" {
  for_each = var.exadata_infrastructures != null ? var.exadata_infrastructures.exadata_infrastructure_config != null ? var.exadata_infrastructures.exadata_infrastructure_config : {} : {}
  compartment_id = each.value.compartment_id != null ? (
    length(regexall("^ocid1.*$", each.value.compartment_id)) > 0 ? each.value.compartment_id : var.compartments_dependency[each.value.compartment_id].id
    ) : (
  length(regexall("^ocid1.*$", var.default_compartment_id)) > 0 ? var.default_compartment_id : var.compartments_dependency[var.default_compartment_id].id)
}


resource "oci_database_cloud_exadata_infrastructure" "these" {
  for_each = var.exadata_infrastructures != null ? var.exadata_infrastructures.exadata_infrastructure_config : {}

  display_name = each.value.display_name
  shape        = each.value.shape
  compartment_id = each.value.compartment_id != null ? (
    can(regex("^ocid1\\.compartment", each.value.compartment_id)) ? each.value.compartment_id : try(var.compartments_dependency[each.value.compartment_id].id, null)
    ) : (
    var.default_compartment_id != null ? (
      can(regex("^ocid1\\.compartment", var.default_compartment_id)) ? var.default_compartment_id : try(var.compartments_dependency[var.default_compartment_id].id, null)
    ) : null
  )
  availability_domain = each.value.availability_domain != null ? each.value.availability_domain : (
    try(data.oci_identity_availability_domains.ads[each.key].availability_domains[0].name, null)
  )
  compute_count = each.value.compute_count
  customer_contacts {
    email = each.value.customer_contacts.email
  }

  database_server_type = each.value.database_server_type
  defined_tags         = each.value.defined_tags != null ? each.value.defined_tags : var.default_defined_tags
  freeform_tags        = merge(each.value.freeform_tags != null ? each.value.freeform_tags : var.default_freeform_tags)

  dynamic "maintenance_window" {
    for_each = each.value.maintenance_window != null ? [each.value.maintenance_window] : var.exadata_infrastructures.default_maintenance_window != null ? [var.exadata_infrastructures.default_maintenance_window] : []
    content {
      custom_action_timeout_in_mins = try(maintenance_window.value.custom_action_timeout_in_mins, null)
      dynamic "days_of_week" {
        for_each = maintenance_window.value.days_of_week != null ? maintenance_window.value.days_of_week : []
        content {
          name = days_of_week.value
        }
      }
      hours_of_day                     = maintenance_window.value.hours_of_day != null ? (length(maintenance_window.value.hours_of_day) > 0 ? maintenance_window.value.hours_of_day : null) : null
      is_custom_action_timeout_enabled = try(maintenance_window.value.is_custom_action_tiemout_enabled, null)
      is_monthly_patching_enabled      = try(maintenance_window.value.is_monthly_patching_enabled, null)
      lead_time_in_weeks               = maintenance_window.value.lead_time_in_weeks != null ? (length(maintenance_window.value.lead_time_in_weeks) > 0 ? maintenance_window.value.lead_time_in_weeks : null) : null

      dynamic "months" {
        for_each = maintenance_window.value.months != null ? maintenance_window.value.months : []
        content {
          name = months.value
        }
      }
      patching_mode  = try(maintenance_window.value.patching_mode, null)
      preference     = try(maintenance_window.value.preference, null)
      weeks_of_month = maintenance_window.value.weeks_of_month != null ? (length(maintenance_window.value.weeks_of_month) > 0 ? maintenance_window.value.weeks_of_month : null) : null
    }
  }

  storage_count       = each.value.storage_count
  storage_server_type = each.value.storage_server_type
  subscription_id     = can(regex("^ocid1\\.", each.value.subscription_id)) ? each.value.subscription_id : try(var.network_dependency[each.value.subscription_id].id, null)
}
