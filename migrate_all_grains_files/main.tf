###############################################################################
# Inputs
###############################################################################
variable "docker_ip4v_address_list" {
  default = []
}

variable "docker_ssh_username" {}
variable "docker_ssh_password" {}

variable "gluster_ip4v_address_list" {
  default = []
}

variable "gluster_ssh_username" {}
variable "gluster_ssh_password" {}

variable "postgres_ip4v_address_list" {
  default = []
}

variable "postgres_ssh_username" {}
variable "postgres_ssh_password" {}

###############################################################################
# Processing
###############################################################################
module "migrate_docker_grains_file" {
  source = "../migrate_grains_file"

  role                          = "docker"
  salt_minion_ip4v_address_list = "${var.docker_ip4v_address_list}"
  salt_minion_ssh_username      = "${var.docker_ssh_username}"
  salt_minion_ssh_password      = "${var.docker_ssh_password}"
}

module "migrate_gluster_grains_file" {
  source = "../migrate_grains_file"

  role                          = "gluster"
  salt_minion_ip4v_address_list = "${var.gluster_ip4v_address_list}"
  salt_minion_ssh_username      = "${var.gluster_ssh_username}"
  salt_minion_ssh_password      = "${var.gluster_ssh_password}"
}

module "migrate_postgres_grains_file" {
  source = "../migrate_grains_file"

  role                          = "postgres"
  salt_minion_ip4v_address_list = "${var.postgres_ip4v_address_list}"
  salt_minion_ssh_username      = "${var.postgres_ssh_username}"
  salt_minion_ssh_password      = "${var.postgres_ssh_password}"
}

###############################################################################
# Outputs
###############################################################################
output "wait_on" {
  value = "All Grains Files Successfully Migrated"

  depends_on = [
    "module.migrate_docker_grains_file",
    "module.migrate_gluster_grains_file",
    "module.migrate_postgres_grains_file",
  ]
}
