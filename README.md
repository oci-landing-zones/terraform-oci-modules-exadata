# OCI Landing Zones Exadata Module
![Landing_Zone_Logo](./landing_zone_300.png)

This repository contains Terraform OCI (Oracle Cloud Infrastructure) modules for Exadata related resources that help customers deploy and manage Exadata infrastructure on OCI.

The following resources are available:

Exadata Infrastructure
VM Clusters
Database
Database Home
Pluggable Database

This module supports being passed an object containing references to OCIDs (Oracle Cloud IDs) that they may depend on. Every input attribute that expects an OCID (typically, attribute names ending in _id or _ids) can be given either a literal OCID or a reference (a key) to the OCID. While these OCIDs can be literally obtained from their sources and pasted when setting the modules input attributes, a superior approach is automatically consuming the outputs of producing modules. For instance, the Exadata Infrastructure module may depend on compartments and networks for deployment. It can be passed a compartments_dependency map and a network_dependency map with objects representing compartments and networks produced by other modules. The external dependency approach helps with the creation of loosely coupled Terraform configurations with clearly defined dependencies between them, avoiding copying and pasting OCIDs.

## Module Inputs
The module accepts the following input variables:

### General
- module_name: The module name. Defaults to "exadata-cloud-service".
- enable_output: Whether Terraform should enable module output. Defaults to true.
- compartments_dependency: A map of objects containing the externally managed compartments this module may depend on.
- network_dependency: A map of objects containing the externally managed network resources this module may depend on.
- default_compartment_id: Default Compartment ID for all resources.
- default_defined_tags: Default defined tags for all resources.
- default_freeform_tags: Default freeform tags for all resources.

### Exadata Infrastructure
- exadata_infrastructures: Exadata infrastructure configuration. This is an object with the following attributes:
  - default_maintenance_window: Default maintenance window configuration.
  - exadata_infrastructure_config: A map of Exadata infrastructure configurations.

Each Exadata infrastructure configuration object has the following attributes:

- display_name: Display name of the Exadata infrastructure.
- shape: Shape of the Exadata infrastructure. Accepted values are Exadata.X11M, Exadata.X9M, and Exadata.X8M.
- compartment_id: Compartment ID of the Exadata infrastructure. Overrides default compartment ID.
- availability_domain: Availability domain of the Exadata infrastructure.
compute_count: Compute count of the Exadata infrastructure.
- customer_contacts: Customer contact information.
- database_server_type: Database server type. Accepted values are X11M-BASE, X11M, X11M-L, and X11M-XL.
- defined_tags: Defined tags for the Exadata infrastructure.
- freeform_tags: Freeform tags for the Exadata infrastructure.
- maintenance_window: Maintenance window configuration.
- storage_count: Storage count of the Exadata infrastructure.
- storage_server_type: Storage server type. Accepted values are X11M-BASE and X11M-HC.
subscription_id: Subscription ID of the Exadata infrastructure.
- subscription_id: Subscription ID of the Exadata infrastructure.


### VM Clusters
- vm_clusters: OCI Database Cloud VM Cluster Configuration. This is a map of VM cluster configurations.

Each VM cluster configuration object has the following attributes:
- backup_subnet_id: Backup subnet ID of the VM cluster.
- exadata_infrastructure_id: Exadata infrastructure ID of the VM cluster.
- compartment_id: Compartment ID of the VM cluster. Overrides default compartment ID.
- cpu_core_count: CPU core count of the VM cluster.
- display_name: Display name of the VM cluster.
- gi_version: GI version of the VM cluster.
- hostname: Hostname of the VM cluster.
- ssh_public_keys: SSH public keys for the VM cluster.
- subnet_id: Subnet ID of the VM cluster.
backup_network_nsg_ids: Backup network NSG IDs of the VM cluster.
- cloud_automation_update_details: Cloud automation update details for the VM cluster.
- cluster_name: Cluster name of the VM cluster.
- data_collection_options: Data collection options for the VM cluster.
- data_storage_percentage: Data storage percentage of the VM cluster.
- data_storage_size_in_tbs: Data storage size in TBs of the VM cluster.
- db_node_storage_size_in_gbs: DB node storage size in GBs of the VM cluster.
- db_servers: DB servers of the VM cluster.
- defined_tags: Defined tags for the VM cluster.
- freeform_tags: Freeform tags for the VM cluster.
- domain: Domain of the VM cluster.
- file_system_configuration_details: File system configuration details for the VM cluster.
- is_local_backup_enabled: Whether local backup is enabled for the VM cluster.
- is_sparse_diskgroup_enabled: Whether sparse diskgroup is enabled for the VM cluster.
- license_model: License model of the VM cluster.
- memory_size_in_gbs: Memory size in GBs of the VM cluster.
- nsg_ids: NSG IDs of the VM cluster.
- ocpu_count: OCPU count of the VM cluster.
- private_zone_id: Private zone ID of the VM cluster.
- scan_listener_port_tcp: Scan listener port TCP of the VM cluster.
- scan_listener_port_tcp_ssl: Scan listener port TCP SSL of the VM cluster.
- security: Security attributes for the VM cluster.
- subscription_id: Subscription ID of the VM cluster.
- system_version: System version of the VM cluster.
- time_zone: Time zone of the VM cluster.
- vm_cluster_type: VM cluster type.

## OCI Landing Zones Modules Collection
This repository is part of a broader collection of repositories containing modules that help customers deploy and manage various OCI resources:

- [Exadata - current repository](https://github.com/)
- [Identity & Access Management](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-iam) - current repository
- [Networking](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-networking)
- [Governance](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-governance)
- [Security](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-security)
- [Observability & Monitoring](https://github.com/oracle-quickstart/terraform-oci-cis-landing-zone-observability)
- [Secure Workloads](https://github.com/oracle-quickstart/terraform-oci-secure-workloads)

The modules in this collection are designed for flexibility, are straightforward to use, and follow best practices.

Using these modules does not require a user extensive knowledge of Terraform or OCI resource types usage. Users declare a JSON object describing the OCI resources according to each module’s specification and minimal Terraform code to invoke the modules. The modules generate outputs that can be consumed by other modules as inputs, allowing for the creation of independently managed operational stacks to automate your entire OCI infrastructure.

## Contributing
See [CONTRIBUTING.md](./CONTRIBUTING.md).

## License
Copyright (c) 2025, Oracle and/or its affiliates.

Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

See [LICENSE](./LICENSE) for more details.

## Known Issues
None.