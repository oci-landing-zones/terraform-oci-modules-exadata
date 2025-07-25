# Copyright (c) 2025, Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

#--------------------------------------------------------------------------------------------------------------------------------------
# 1. Rename this file to main.tf
# 2. Provide values for "Tenancy Connectivity Variables".
# 3. Replace <REPLACE-WITH-*> placeholders in "Input Variables" with appropriate values.
#--------------------------------------------------------------------------------------------------------------------------------------

module "exacs" {
  source = "../../"

  # ------------------------------------------------------
  # ----- Tenancy Connectivity Variables
  # ------------------------------------------------------

  tenancy_ocid         = "..." # Get this from OCI Console (after logging in, go to top-right-most menu item and click option "Tenancy: <your tenancy name>").
  user_ocid            = "..." # Get this from OCI Console (after logging in, go to top-right-most menu item and click option "My profile").
  fingerprint          = "..." # The fingerprint can be gathered from your user account. In the "My profile page, click "API keys" on the menu in left hand side.
  private_key_path     = "..." # This is the full path on your local system to the API signing private key.
  private_key_password = "..." # This is the password that protects the private key, if any.
  region               = "..." # The region name.

  #---------------------------------------
  # ----- Input Variables
  #---------------------------------------
  availability_domain = ""
}
