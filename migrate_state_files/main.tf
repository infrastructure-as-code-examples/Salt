variable "package_name" {}

variable "salt_master_ip4v_address_list" {
  default = []
}

variable "salt_master_ssh_username" {}
variable "salt_master_ssh_password" {}

variable "linux_distribution" {}

variable "wait_on" {
  default = []
}

###############################################################################
# Force Inter-Module Dependency
###############################################################################
resource "null_resource" "waited_on" {
  count = "${length(var.wait_on)}"

  provisioner "local-exec" {
    command = "echo Dependency Resolved: ${var.package_name}--->${element(var.wait_on, count.index)}"
  }
}

###############################################################################
# Migrate State Files for Specific Server "Role"
###############################################################################
resource "null_resource" "migrate_state_files" {
  count = "${length(var.salt_master_ip4v_address_list)}"

  triggers {
    state_file = "${md5(file("${path.module}/configuration/${var.package_name}/${var.linux_distribution}/init.sls"))}"
  }

  connection {
    user     = "${var.salt_master_ssh_username}"
    password = "${var.salt_master_ssh_password}"
    host     = "${element(var.salt_master_ip4v_address_list, count.index)}"
    type     = "ssh"
  }

  provisioner "remote-exec" {
    inline = [
      "set -eou pipefail",
      "mkdir -p /tmp/${var.package_name}",
    ]
  }

  provisioner "file" {
    source      = "${path.module}/configuration/${var.package_name}/${var.linux_distribution}/"
    destination = "/tmp/${var.package_name}"
  }

  provisioner "remote-exec" {
    inline = [
      "set -eou pipefail",
      "if [ -d /srv/salt/${var.package_name} ]; then",
      "  sudo rm -rf /srv/salt/${var.package_name}",
      "fi",
      "sudo mv /tmp/${var.package_name} /srv/salt",
    ]
  }

  depends_on = [
    "null_resource.waited_on",
  ]
}

###############################################################################
# Outputs
###############################################################################
output "wait_on" {
  value      = "State Files Successfully Migrated: ${var.package_name}"
  depends_on = ["null_resource.migrate_state_files"]
}
