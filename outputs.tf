# Copyright (c) 2025, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "cloud_exadata_infrastructures" {
  description = "The deployed Exadata Infrastructures in the OCI Database Service."
  value       = var.enable_output ? oci_database_cloud_exadata_infrastructure.these : null
}

output "cloud_vm_clusters" {
  description = "The deployed Cloud VM Clusters in the OCI Database Service."
  value       = var.enable_output ? oci_database_cloud_vm_cluster.these : null
}

output "database_home" {
  description = "The deployed Databases Homes in the OCI Database Service."
  value       = var.enable_output ? oci_database_db_home.these : null
}

output "database" {
  description = "The deployed Databases in the OCI Database Service."
  value       = var.enable_output ? oci_database_database.these : null
}

output "pluggable_database" {
  description = "The deployed Pluggable Databases in the OCI Database Service."
  value       = var.enable_output ? oci_database_pluggable_database.these : null
}


