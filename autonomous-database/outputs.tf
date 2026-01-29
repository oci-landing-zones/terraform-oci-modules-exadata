# Copyright (c) 2023, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "autonomous_databases" {
  description = "The Autonomous Databases"
  value       = var.enable_output ? { for k, v in oci_database_autonomous_database.these : k => { "display_name" : v.display_name, "ocid" : v.id, "ecpu_count" : v.compute_count, "db_workload" : v.db_workload } } : null
}
