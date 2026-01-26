# Copyright (c) 2025, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.
locals {
  db_configs = { for k, v in var.autonomous_databases_configuration.databases : k => {
    compartment_id                   = v.compartment_id != null ? (length(regexall("^ocid1.*$", v.compartment_id)) > 0 ? v.compartment_id : var.compartments_dependency[v.compartment_id].id) : (length(regexall("^ocid1.*$", var.autonomous_databases_configuration.default_compartment_id)) > 0 ? var.autonomous_databases_configuration.default_compartment_id : var.compartments_dependency[var.autonomous_databases_configuration.default_compartment_id].id)
    db_name                          = v.db_name
    db_version                       = v.is_dedicated ? null : v.db_version
    db_edition                       = v.db_edition
    is_dedicated                     = v.is_dedicated
    autonomous_container_database_id = try(length(regexall("^ocid1.*$", v.autonomous_container_db_id)) > 0 ? v.autonomous_container_db_id : var.databases_dependency.container_databases[v.autonomous_container_db_id].id, null)
    ecpu_count                       = v.ecpu_count
    data_storage_size_in_gbs         = v.db_workload == "DW" ? null : v.non_dw_storage_size_in_gbs
    data_storage_size_in_tbs         = v.db_workload == "DW" ? v.dw_storage_size_in_tbs : null
    admin_password                   = v.admin_password
    display_name                     = coalesce(v.display_name, v.db_name)
    db_workload                      = v.db_workload
    is_free_tier                     = v.is_free_tier
    is_dev_tier                      = v.is_dev_tier
    license_model                    = v.is_dedicated ? null : v.license_model # default "LICENSE_INCLUDED", defaults to null for dedicated
    enable_cpu_auto_scaling          = v.enable_cpu_auto_scaling
    enable_storage_auto_scaling      = v.is_dedicated ? null : v.enable_storage_auto_scaling
    character_set                    = v.character_set
    national_character_set           = v.national_character_set
    backup_retention_in_days         = v.is_dedicated ? null : v.backup_retention_in_days
    whitelisted_ips                  = try(v.networking.whitelisted_ips, null) != null ? v.networking.whitelisted_ips : null

    private_endpoint_label = try(v.networking.enable_private_endpoint, false) == true ? "${lower(v.db_name)}-private-endpoint" : ""
    private_endpoint_ip    = try(v.networking.enable_private_endpoint, false) == true && try(v.networking.private_endpoint_ip, null) != null ? v.networking.private_endpoint_ip : null
    nsg_ids                = v.is_dedicated ? null : try(v.networking.enable_private_endpoint, false) == true ? [for nsg in coalesce(v.networking.network_security_groups, []) : (length(regexall("^ocid1.*$", nsg)) > 0 ? nsg : var.network_dependency["network_security_groups"][nsg].id)] : null
    subnet_id              = try(v.networking.enable_private_endpoint, false) == true && try(v.networking.subnet_id, null) != null ? ((length(regexall("^ocid1.*$", v.networking.subnet_id)) > 0 ? v.networking.subnet_id : var.network_dependency["subnets"][v.networking.subnet_id].id)) : null
    security_attributes    = try(v.networking.enable_private_endpoint, false) == true ? (try(v.security.zpr_attributes, null) != null ? merge([for a in v.security.zpr_attributes : { "${a.namespace}.${a.attr_name}.value" : a.attr_value, "${a.namespace}.${a.attr_name}.mode" : a.mode }]...) : null) : null

    # tde attributes are inherited from ACDB when deploying on a dedicated exa infra
    deploy_iam_policy_and_dyn_group_for_encryption_key = v.is_dedicated == true ? false : try(v.security.tde.deploy_iam_policy_and_dyn_group_for_encryption_key, false)
    deploy_new_oci_encryption_key                      = v.is_dedicated == true ? false : try(v.security.tde.deploy_new_oci_encryption_key, false)
    oci_vault_id                                       = v.is_dedicated == true ? null : try(v.security.tde.existing_oci_vault_id, null) != null ? (length(regexall("^ocid1.*$", v.security.tde.existing_oci_vault_id)) > 0 ? v.security.tde.existing_oci_vault_id : var.kms_dependency[v.security.tde.existing_oci_vault_id].id) : null
    oci_encryption_key_id                              = v.is_dedicated == true ? null : try(v.security.tde.existing_oci_encryption_key_id, null) != null ? (length(regexall("^ocid1.*$", v.security.tde.existing_oci_encryption_key_id)) > 0 ? v.security.tde.existing_oci_encryption_key_id : var.kms_dependency[v.security.tde.existing_oci_encryption_key_id].id) : null

    defined_tags  = coalesce(v.defined_tags, var.autonomous_databases_configuration.default_defined_tags)
    freeform_tags = coalesce(v.freeform_tags, var.autonomous_databases_configuration.default_freeform_tags)
    }
  }
}

resource "oci_database_autonomous_database" "these" {
  depends_on                          = [null_resource.wait]
  for_each                            = local.db_configs
  compartment_id                      = each.value.compartment_id
  subnet_id                           = each.value.subnet_id
  db_name                             = each.value.db_name
  db_version                          = each.value.db_version
  database_edition                    = each.value.db_edition
  is_dedicated                        = each.value.is_dedicated
  autonomous_container_database_id    = each.value.autonomous_container_database_id
  compute_model                       = "ECPU"
  compute_count                       = each.value.ecpu_count
  data_storage_size_in_tbs            = each.value.data_storage_size_in_tbs
  data_storage_size_in_gb             = each.value.data_storage_size_in_gbs
  admin_password                      = each.value.admin_password
  display_name                        = each.value.display_name
  db_workload                         = each.value.db_workload
  is_free_tier                        = each.value.is_free_tier
  is_dev_tier                         = each.value.is_dev_tier
  license_model                       = each.value.license_model
  is_auto_scaling_enabled             = each.value.enable_cpu_auto_scaling
  is_auto_scaling_for_storage_enabled = each.value.enable_storage_auto_scaling
  character_set                       = each.value.character_set
  ncharacter_set                      = each.value.national_character_set
  backup_retention_period_in_days     = each.value.backup_retention_in_days
  nsg_ids                             = each.value.nsg_ids
  whitelisted_ips                     = each.value.whitelisted_ips
  defined_tags                        = each.value.defined_tags
  freeform_tags                       = each.value.freeform_tags
  private_endpoint_label              = each.value.private_endpoint_label
  security_attributes                 = each.value.security_attributes
  dynamic "encryption_key" {
    for_each = each.value.is_dedicated ? [] : [1]
    content {
      autonomous_database_provider = "OCI"
      kms_key_id                   = try(module.master_keys[0].keys["${each.key}-KEY"].id, each.value.oci_encryption_key_id)
      vault_id                     = each.value.oci_vault_id
    }
  }
}
resource "null_resource" "wait" {
  depends_on = [module.policies]
  provisioner "local-exec" {
    command = "sleep 30"
  }
}
