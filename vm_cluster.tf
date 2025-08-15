# Copyright (c) 2025, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {

  vm_clusters = { for vm_key, vm in coalesce(var.vm_clusters, {}) : vm_key => merge(vm, {
    exadata_infra_id = can(regex("^ocid1\\.cloudexadatainfrastructure.", vm.exadata_infrastructure_id)) ? vm.exadata_infrastructure_id : try(oci_database_cloud_exadata_infrastructure.these[vm.exadata_infrastructure_id].id, null)
    compartment_id = vm.compartment_id != null ? (
      can(regex("^ocid1\\.compartment", vm.compartment_id)) ? vm.compartment_id : try(var.compartments_dependency[vm.compartment_id].id, null)) : try(oci_database_cloud_exadata_infrastructure.these[vm.exadata_infrastructure_id].id, (
    can(regex("^ocid1\\.compartment", var.default_compartment_id)) ? var.default_compartment_id : try(var.compartments_dependency[var.default_compartment_id].id, null)))

    subnet_id              = can(regex("^ocid1\\.subnet", vm.subnet_id)) ? vm.subnet_id : try(var.network_dependency[vm.subnet_id].id, null)
    backup_subnet_id       = can(regex("^ocid1\\.subnet", vm.backup_subnet_id)) ? vm.backup_subnet_id : try(var.network_dependency[vm.backup_subnet_id].id, null)
    nsg_ids                = [for id in coalesce(vm.nsg_ids, []) : can(regex("^ocid1\\.networksecuritygroup", id)) ? id : try(var.network_dependency[id].id, null)]
    backup_network_nsg_ids = [for id in coalesce(vm.backup_network_nsg_ids, []) : can(regex("^ocid1\\.networksecuritygroup", id)) ? id : try(var.network_dependency[id].id, null)]
  }) }
}

resource "oci_database_cloud_vm_cluster" "these" {
  for_each = local.vm_clusters

  cloud_exadata_infrastructure_id = each.value.exadata_infra_id
  compartment_id                  = each.value.compartment_id
  display_name                    = each.value.display_name
  cpu_core_count                  = each.value.cpu_core_count
  gi_version                      = each.value.gi_version
  hostname                        = each.value.hostname
  ssh_public_keys                 = each.value.ssh_public_keys
  subnet_id                       = each.value.subnet_id
  backup_subnet_id                = each.value.backup_subnet_id
  data_storage_size_in_tbs        = each.value.data_storage_size_in_tbs
  db_node_storage_size_in_gbs     = each.value.db_node_storage_size_in_gbs
  memory_size_in_gbs              = each.value.memory_size_in_gbs

  # Optional
  backup_network_nsg_ids      = length(each.value.backup_network_nsg_ids) > 0 ? each.value.backup_network_nsg_ids : null
  defined_tags                = each.value.defined_tags != null ? each.value.defined_tags : var.default_freeform_tags
  freeform_tags               = each.value.freeform_tags != null ? each.value.freeform_tags : var.default_freeform_tags
  is_local_backup_enabled     = each.value.is_local_backup_enabled
  is_sparse_diskgroup_enabled = each.value.is_sparse_diskgroup_enabled
  nsg_ids                     = length(each.value.nsg_ids) > 0 ? each.value.nsg_ids : null
  scan_listener_port_tcp      = each.value.scan_listener_port_tcp
  scan_listener_port_tcp_ssl  = each.value.scan_listener_port_tcp_ssl
  time_zone                   = each.value.time_zone
  cluster_name                = each.value.cluster_name
  data_storage_percentage     = each.value.data_storage_percentage
  db_servers                  = each.value.db_servers
  domain                      = each.value.domain
  license_model               = each.value.license_model
  ocpu_count                  = each.value.ocpu_count
  private_zone_id             = each.value.private_zone_id
  subscription_id             = each.value.subscription_id
  system_version              = each.value.system_version
  vm_cluster_type             = each.value.vm_cluster_type

  security_attributes = try(each.value.security.zpr_attributes, null) != null ? merge([for a in each.value.security.zpr_attributes : { "${a.namespace}.${a.attr_name}.value" : a.attr_value, "${a.namespace}.${a.attr_name}.mode" : a.mode }]...) : null

  dynamic "data_collection_options" {
    for_each = each.value.data_collection_options != null ? [each.value.data_collection_options] : []
    content {
      is_diagnostics_events_enabled = data_collection_options.value.is_diagnostics_events_enabled
      is_health_monitoring_enabled  = data_collection_options.value.is_health_monitoring_enabled
      is_incident_logs_enabled      = data_collection_options.value.is_incident_logs_enabled
    }
  }

  dynamic "cloud_automation_update_details" {
    for_each = each.value.cloud_automation_update_details != null ? [each.value.cloud_automation_update_details] : []
    content {
      dynamic "apply_update_time_preference" {
        for_each = cloud_automation_update_details.value.apply_update_time_preference != null ? [cloud_automation_update_details.value.apply_update_time_preference] : []
        content {
          apply_update_preferred_start_time = apply_update_time_preference.value.apply_update_preferred_start_time
          apply_update_preferred_end_time   = apply_update_time_preference.value.apply_update_preferred_end_time
        }
      }
      dynamic "freeze_period" {
        for_each = cloud_automation_update_details.value.freeze_period != null ? [cloud_automation_update_details.value.freeze_period] : []
        content {
          freeze_period_start_time = freeze_period.value.freeze_period_start_time
          freeze_period_end_time   = freeze_period.value.freeze_period_end_time
        }
      }
      is_early_adoption_enabled = cloud_automation_update_details.value.is_early_adoption_enabled
      is_freeze_period_enabled  = cloud_automation_update_details.value.is_freeze_period_enabled
    }
  }

  dynamic "file_system_configuration_details" {
    for_each = each.value.file_system_configuration_details != null ? each.value.file_system_configuration_details : {}
    content {
      file_system_size_gb = file_system_configuration_details.value.file_system_size_gb
      mount_point         = file_system_configuration_details.value.mount_point
    }
  }
}
