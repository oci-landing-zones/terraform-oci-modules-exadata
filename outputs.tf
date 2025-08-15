# Copyright (c) 2025, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "vm_clusters" {
  description = "The deployed Cloud VM Clusters in the OCI Database Service."
  value = { for k, v in oci_database_cloud_vm_cluster.these : k => {
    name = v.display_name
    cloud_vm_cluster_ocid : v.id
    vip_ids : v.vip_ids
    defined_tags : v.defined_tags
    freeform_tags : v.freeform_tags
    }
  }
}
