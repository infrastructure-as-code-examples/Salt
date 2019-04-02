###############################################################################
# Provider Configuration
###############################################################################
provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"

  allow_unverified_ssl = true
}

module "migrate_top_files" {
  source = "./migrate_top"

  salt_master_ip4v_address_list = "${var.salt_master_ip4v_address_list}"
  salt_master_ssh_username      = "${var.ssh_username}"
  salt_master_ssh_password      = "${var.ssh_password}"
}

module "migrate_all_state_files" {
  source = "./migrate_all_state_files"

  salt_master_ip4v_address_list = "${var.salt_master_ip4v_address_list}"
  salt_master_ssh_username      = "${var.ssh_username}"
  salt_master_ssh_password      = "${var.ssh_password}"
  linux_distribution            = "${var.linux_distribution}"
}

module "migrate_all_grains_files" {
  source = "./migrate_all_grains_files"

  docker_ip4v_address_list   = "${var.docker_ip4v_address_list}"
  docker_ssh_username        = "${var.ssh_username}"
  docker_ssh_password        = "${var.ssh_password}"
  gluster_ip4v_address_list  = "${var.gluster_ip4v_address_list}"
  gluster_ssh_username       = "${var.ssh_username}"
  gluster_ssh_password       = "${var.ssh_password}"
  postgres_ip4v_address_list = "${var.postgres_ip4v_address_list}"
  postgres_ssh_username      = "${var.ssh_username}"
  postgres_ssh_password      = "${var.ssh_password}"
}
