# Copyright (c) 2025, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.
locals {
  # Resolve references and defaults for pluggable database creation
  pluggable_databases = {
    for key, pdb in coalesce(var.pluggable_databases_config, {}) :
    key => merge(pdb, {
      # Resolve Container Database ID: use as-is if OCID, or reference created container DB by key
      container_database_id = can(regex("^ocid1\\.dbhome\\.", pdb.container_database_id)) ? pdb.container_database_id : try(oci_database_database.these[pdb.container_database_id].id, null)
      # Tag defaults
      defined_tags  = try(pdb.defined_tags, var.default_defined_tags)
      freeform_tags = try(pdb.freeform_tags, var.default_freeform_tags)
    })
  }
}

resource "oci_database_pluggable_database" "these" {
  for_each = nonsensitive(local.pluggable_databases)
  #Required
  container_database_id = each.value.container_database_id
  pdb_name              = each.value.pdb_name
  #Optional
  container_database_admin_password = each.value.container_database_admin_password
  defined_tags                      = each.value.defined_tags
  freeform_tags                     = each.value.freeform_tags
  kms_key_version_id                = each.value.kms_key_version_id
  pdb_admin_password                = each.value.pdb_admin_password
  dynamic "pdb_creation_type_details" {
    for_each = each.value.pdb_creation_type_details != null ? [each.value.pdb_creation_type_details] : []
    content {
      creation_type                = pdb_creation_type_details.value.creation_type
      source_pluggable_database_id = pdb_creation_type_details.value.source_pluggable_database_id
      dblink_user_password         = pdb_creation_type_details.value.dblink_user_password
      dblink_username              = pdb_creation_type_details.value.dblink_username
      is_thin_clone                = pdb_creation_type_details.value.is_thin_clone
      dynamic "refreshable_clone_details" {
        for_each = try(pdb_creation_type_details.value.refreshable_clone_details, null) != null ? [pdb_creation_type_details.value.refreshable_clone_details] : []
        content {
          is_refreshable_clone = refreshable_clone_details.value.is_refreshable_clone
        }
      }
      source_container_database_admin_password = pdb_creation_type_details.value.source_container_database_admin_password # Sensitive
    }
  }
  should_create_pdb_backup           = each.value.should_create_pdb_backup
  should_pdb_admin_account_be_locked = each.value.should_pdb_admin_account_be_locked
  tde_wallet_password                = each.value.tde_wallet_password

  lifecycle {
    ignore_changes = [
      # Ignore changes to the following attributes after creation
      container_database_id,
      container_database_admin_password,
      pdb_admin_password
    ]
  }

  timeouts {
    create = "60m"
    update = "60m"
    delete = "120m"
  }
}
