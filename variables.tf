# Copyright (c) 2025, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# ------------------------------------------------------
# ----- General
#-------------------------------------------------------
variable "tenancy_ocid" {
  default = ""
}
variable "user_ocid" {
  default = ""
}
variable "fingerprint" {
  default = ""
}
variable "private_key_path" {
  default = ""
}
variable "private_key_password" {
  default = ""
}

variable "region" {
  description = "The region where resources are deployed."
  type        = string
}

variable "module_name" {
  description = "The module name."
  type        = string
  default     = "exadata-cloud-service"
}

variable "enable_output" {
  description = "Whether Terraform should enable module output."
  type        = bool
  default     = true
}

variable "compartments_dependency" {
  description = "A map of objects containing the externally managed compartments this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute of string type set with the compartment OCID."
  type        = map(any)
  default     = null
}

variable "network_dependency" {
  description = "A map of objects containing the externally managed network resources (e.g., subnets, NSGs) this module may depend on. All map objects must have the same type and must contain at least an 'id' attribute of string type set with the resource OCID."
  type        = map(any)
  default     = null
}

variable "default_compartment_id" {
  description = "Default Compartment ID for all resources."
  type        = string
  default     = null

}

variable "default_defined_tags" {
  description = "Default defined tags for all resources."
  type        = map(string)
  default     = {}
}

variable "default_freeform_tags" {
  description = "Default freeform tags for all resources."
  type        = map(string)
  default     = {}
}

variable "exadata_infrastructure_config" {
  description = "Exadata infrastructure configuration."
  type = map(object({
    # Attributes for oci_database_cloud_exadata_infrastructure (from https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/database_cloud_exadata_infrastructure)
    display_name        = string
    shape               = string           # e.g., "Exadata.X9M"
    compartment_id      = optional(string) # Overrides default; literal OCID or key in compartments_dependency
    availability_domain = optional(string, "1")

    compute_count = optional(number)
    customer_contacts = optional(object({
      email = optional(string)
    }))
    database_server_type = optional(string)
    defined_tags         = optional(map(string))
    freeform_tags        = optional(map(string))

    maintenance_window = optional(object({
      custom_action_timeout_in_mins = optional(number)
      days_of_week = optional(object({
        name = list(string)
      }))
      hours_of_day                     = optional(list(number))
      is_custom_action_tiemout_enabled = optional(bool)
      is_monthly_patching_enabled      = optional(bool)
      lead_time_in_weeks               = optional(number)

      months = optional(object({
        name = list(string)
      }))
      patching_mode  = optional(string)
      preference     = optional(string, "NO_PREFERENCE") # e.g., "NO_PREFERENCE"
      weeks_of_month = optional(list(number))
    }))
    storage_count       = optional(number)
    storage_server_type = optional(string)
    subscription_id     = optional(string)
  }))
}

variable "vm_clusters_config" {
  description = "OCI Database Cloud VM Cluster Configuration."
  type = map(object({
    # Attributes for oci_database_cloud_vm_cluster (from https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/database_cloud_vm_cluster)
    backup_subnet_id = string # Literal OCID or key in network_dependency

    database_cloud_exadata_infrastructure_id = string           # OCID or key of the database cloud exadata infrastructure.
    compartment_id                           = optional(string) # Overrides default; literal OCID or key in compartments_dependency
    cpu_core_count                           = number
    display_name                             = string
    gi_version                               = string # e.g., "19.0.0.0"
    hostname                                 = string
    ssh_public_keys                          = list(string)
    subnet_id                                = string # Literal OCID or key in network_dependency

    backup_network_nsg_ids = optional(list(string)) # Literal OCIDs or keys in network_dependency
    cloud_automation_update_detaills = optional(map({
      apply_update_time_preference = optional(map({
        apply_update_preferred_end_time   = optional(string)
        apply_update_preferred_start_time = optional(string)
      }))
      freeze_period = map({
        freeze_period_end_time   = optional(string)
        freeze_period_start_time = optional(string)
      })
      is_early_adoption_enabled = optional(bool)
      is_freeze_period_enabled  = optional(bool)
    }))

    cluster_name = optional(string)
    data_collection_options = optional(map({
      is_diagnostics_events_enabled = optional(bool)
      is_health_monitoring_enabled  = optional(bool)
      is_incident_logs_enabled      = optional(bool)
    }))
    data_storage_percentage     = optional(number) #. Accepted values are 35, 40, 60 and 80. 
    data_storage_size_in_tbs    = optional(number)
    db_node_storage_size_in_gbs = optional(number)
    db_servers                  = optional(list(string))
    defined_tags                = optional(map(string))
    freeform_tags               = optional(map(string))
    domain                      = optional(string)
    file_system_configuration_details = optional(map({
      file_system_size_gb = optional(number)
      mount_point         = optional(string)
    }))
    is_local_backup_enabled     = optional(bool, false)
    is_sparse_diskgroup_enabled = optional(bool, false)
    license_model               = optional(string)
    memory_size_in_gbs          = optional(number)
    nsg_ids                     = optional(list(string))
    ocpu_count                  = optional(number)
    private_zone_id             = optional(string)
    scan_listener_port_tcp      = optional(number)
    scan_listener_port_tcp_ssl  = optional(number)
    security_attributes         = optional(object)
    subscription_id             = optional(string)
    system_version              = optional(string)
    time_zone                   = optional(string)
    vm_cluster_type             = optional(string)
  }))
}


variable "db_home_config" {
  description = "DB Home Config"
  type = map(object({
    # Attributes for oci_database_db_home (from https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/database_db_home)
    database = optional(map({
      admin_password             = string
      backup_id                  = optional(string)
      backup_tde_password        = optional(string)
      character_set              = optional(string)
      database_id                = optional(string)
      database_software_image_id = optional(string)
      db_backup_config = optional(map({
        auto_backup_enabled     = optional(bool)
        auto_backup_window      = optional(string)
        auto_full_backup_day    = optional(string)
        auto_full_backup_window = optional(string)
        backup_deletion_policy  = optional(string)
        backup_destination_details = optional(map({
          dbrs_policy_id = optional(string)
          id             = optional(string)
          is_remote      = optional(bool)
          remote_region  = optional(string)
          type           = optional(string)
        }))
        recovery_window_in_days   = optional(number)
        run_immediate_full_backup = optional(bool)
      }))
      db_name      = optional(string)
      db_workload  = optional(string)
      defined_tags = optional(map(string))
      encryption_key_location_details = optional(map({
        provider_type           = string
        azure_encryption_key_id = optional(string)
        hsm_password            = optional(string)
      }))
      freeform_tags       = optional(map(string))
      key_store_id        = optional(string)
      kms_key_id          = optional(string)
      kms_key_version_id  = optional(string)
      ncharacter_set      = optional(string)
      pdb_name            = optional(string)
      pluggable_databases = optional(list(string))
      sid_prefix          = optional(string)
      source_encryption_key_location_details = optional(map({
        provider_type           = string
        azure_encryption_key_id = optional(string)
        hsm_password            = optional(string)
      }))
      tde_wallet_password                   = optional(string)
      time_stamp_for_point_in_time_recovery = optional(string)
      vault_id                              = optional(string)
    }))
    database_software_image_id  = optional(string)
    db_system_id                = optional(string)
    db_version                  = optional(string) # e.g., "19.0.0.0"
    defined_tags                = optional(map(string))
    display_name                = optional(string)
    enable_database_delete      = optional(bool, false)
    freeform_tags               = optional(map(string))
    is_desupported_version      = optional(bool)
    is_unified_auditing_enabled = optional(bool)
    kms_key_id                  = optional(string)
    kms_key_version_id          = optional(string)
    source                      = optional(string, "NONE") # Valid values: "NONE", "DB_BACKUP", "VM_CLUSTER_NEW"
    vm_cluster_id               = optional(string)
  }))
}

variable "databases_config" {
  description = "Configuration for the database resources"
  type = map(object({
    database = object({
      admin_password             = string #sensitive
      db_name                    = string
      backup_id                  = optional(string) # For restore
      backup_tde_password        = optional(string)
      character_set              = optional(string)
      database_software_image_id = optional(string)
      db_backup_config = object({
        auto_backup_enabled     = optional(bool)
        auto_backup_window      = optional(string)
        auto_full_backup_day    = optional(string)
        auto_full_backup_window = optional(string)
        backup_deletion_policy  = optional(string)
        backup_destination_details = object({
          dbrs_policy_id = optional(string)
          id             = optional(string)
          is_remote      = optional(bool)
          remote_region  = optional(string)
          type           = optional(string)
        })
        recovery_window_in_days   = optional(number)
        run_immediate_full_backup = optional(bool)
      })
      db_unique_name = optional(string)
      db_workload    = optional(string) # e.g., "OLTP"
      defined_tags   = optional(map(string))
      encryption_key_location_details = object({
        provider_type           = string
        azure_encryption_key_id = optional(string)
        hsm_password            = optional(string)
      })
      freeform_tags                = optional(map(string))
      key_store_id                 = optional(string)
      is_active_data_guard_enabled = optional(bool)
      kms_key_id                   = optional(string)
      kms_key_version_id           = optional(string)
      ncharacter_set               = optional(string)
      pdb_name                     = optional(string)
      pluggable_databases          = optional(list(string))
      protection_mode              = optional(string)
      sid_prefix                   = optional(string)
      source_database_id           = optional(string)
      source_tde_wallet_password   = optional(string)
      source_encryption_key_location_details = object({
        provider_type           = string
        azure_encryption_key_id = optional(string)
        hsm_password            = optional(string)
      })
      tde_wallet_password = optional(string)
      transport_type      = optional(string)
      vault_id            = optional(string)
    })
    db_home_id         = string
    source             = string
    db_version         = optional(string)
    kms_key_id         = optional(string)
    kms_key_version_id = optional(string)
  }))
}

variable "pluggable_databases_config" {
  description = "Pluggable Database Config"
  type = map(object({
    container_database_id = string # Literal OCID or network dependency key
    pbd_name              = string

    container_database_admin_password = optional(string) # Sensitive
    defined_tags                      = optional(map(string))
    freeform_tags                     = optional(map(string))
    kms_key_version_id                = optional(string)
    pdb_admin_password                = optional(string) # Sensitive
    pdb_creation_type_details = optional(map({
      creation_type                = string
      source_pluggable_database_id = string
      dblink_user_password         = optional(string)
      dblink_username              = optional(string)
      is_thin_clone                = optional(bool)
      refreshable_clone_details = optional(map({
        is_refreshable_clone = optional(bool)
      }))
      source_container_database_admin_password = optional(string) # Sensitive
    }))
    should_create_pdb_backup           = optional(bool)
    should_pdb_admin_account_be_locked = optional(bool)
    tde_wallet_password                = optional(string)
  }))
}
