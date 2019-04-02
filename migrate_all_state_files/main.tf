###############################################################################
# Inputs
###############################################################################
variable "salt_master_ip4v_address_list" {
  default = []
}

variable "salt_master_ssh_username" {}
variable "salt_master_ssh_password" {}

variable "linux_distribution" {}

###############################################################################
# Processing
###############################################################################
module "migrate_docker_state_files" {
  source = "../migrate_state_files"

  package_name                  = "docker-package"
  salt_master_ip4v_address_list = "${var.salt_master_ip4v_address_list}"
  salt_master_ssh_username      = "${var.salt_master_ssh_username}"
  salt_master_ssh_password      = "${var.salt_master_ssh_password}"
  linux_distribution            = "${var.linux_distribution}"
}

module "migrate_gluster_server_state_files" {
  source = "../migrate_state_files"

  package_name                  = "gluster-package"
  salt_master_ip4v_address_list = "${var.salt_master_ip4v_address_list}"
  salt_master_ssh_username      = "${var.salt_master_ssh_username}"
  salt_master_ssh_password      = "${var.salt_master_ssh_password}"
  linux_distribution            = "${var.linux_distribution}"
}

module "migrate_gluster_client_state_files" {
  source = "../migrate_state_files"

  package_name                  = "gluster-client"
  salt_master_ip4v_address_list = "${var.salt_master_ip4v_address_list}"
  salt_master_ssh_username      = "${var.salt_master_ssh_username}"
  salt_master_ssh_password      = "${var.salt_master_ssh_password}"
  linux_distribution            = "${var.linux_distribution}"
}

module "migrate_postgres_state_files" {
  source = "../migrate_state_files"

  package_name                  = "postgres-package"
  salt_master_ip4v_address_list = "${var.salt_master_ip4v_address_list}"
  salt_master_ssh_username      = "${var.salt_master_ssh_username}"
  salt_master_ssh_password      = "${var.salt_master_ssh_password}"
  linux_distribution            = "${var.linux_distribution}"
}

module "migrate_mule_state_files" {
  source = "../migrate_state_files"

  package_name                  = "mule-package"
  salt_master_ip4v_address_list = "${var.salt_master_ip4v_address_list}"
  salt_master_ssh_username      = "${var.salt_master_ssh_username}"
  salt_master_ssh_password      = "${var.salt_master_ssh_password}"
  linux_distribution            = "${var.linux_distribution}"
}

###############################################################################
# Outputs
###############################################################################
output "wait_on" {
  value = "All State Files Successfully Migrated"

  depends_on = [
    "module.migrate_docker_state_files",
    "module.migrate_gluster_server_state_files",
    "module.migrate_gluster_client_state_files",
    "module.migrate_postgres_state_files",
  ]
}
