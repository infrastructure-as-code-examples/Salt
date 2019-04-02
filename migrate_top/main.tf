variable "salt_master_ip4v_address_list" {
  default = []
}

variable "salt_master_ssh_username" {}
variable "salt_master_ssh_password" {}

variable "wait_on" {
  default = []
}

###############################################################################
# Force Inter-Module Dependency
###############################################################################
resource "null_resource" "waited_on" {
  count = "${length(var.wait_on)}"

  provisioner "local-exec" {
    command = "echo Dependency Resolved: ${element(var.wait_on, count.index)}"
  }
}

###############################################################################
# Migrate State Files for Specific Server "Role"
###############################################################################
resource "null_resource" "migrate_top_file" {
  count = "${length(var.salt_master_ip4v_address_list)}"

  triggers {
    top_file = "${md5(file("${path.module}/configuration/top.sls"))}"
  }

  connection {
    user     = "${var.salt_master_ssh_username}"
    password = "${var.salt_master_ssh_password}"
    host     = "${element(var.salt_master_ip4v_address_list, count.index)}"
    type     = "ssh"
  }

  provisioner "file" {
    source      = "${path.module}/configuration/top.sls"
    destination = "/tmp/top.sls"
  }

  provisioner "remote-exec" {
    inline = [
      "set -eou pipefail",
      "if [ ! -d /srv/salt ]; then",
      "  sudo mkdir -p /srv/salt",
      "elif [ -f /srv/salt/top.sls ]; then",
      "  sudo rm /srv/salt/top.sls",
      "fi",
      "sudo mv /tmp/top.sls /srv/salt/top.sls",
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
  value      = "Top Files Successfully Migrated"
  depends_on = ["null_resource.migrate_top_file"]
}
