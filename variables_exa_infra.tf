# Copyright (c) 2025, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

# ------------------------------------------------------
# ----- Exadata Infrastructure
#-------------------------------------------------------


variable "exa_infra_display_name" {
  description = "The user-friendly name for the cloud Exadata infrastructure resource. The name does not need to be unique."
  type        = string
}

variable "shape" {
  description = "The shape of the cloud Exadata infrastructure resource."
  type        = string
}

variable "cluster_placement_group_id" {

}

variable "compute_count" {

}

variable "customer_contacts_email" {

}

variable "database_server_type" {

}

variable "storage_count" {

}

variable "storage_server_type" {

}

variable "subscription_id" {

}

# Maintenance Window
variable "custom_action_timeout_in_mins" {

}

variable "days_of_week_name" {

}

variable "hours_of_day" {

}

variable "is_custom_action_timeone_enabled" {

}

variable "is_monthly_patching_enabled" {

}

variable "lead_time_in_weeks" {

}

variable "months_name" {

}

variable "patching_mode" {

}

variable "preference" {

}

variable "weeks_of_month" {

}
