variable "role" {}

variable "salt_minion_ip4v_address_list" {
  default = []
}

variable "salt_minion_ssh_username" {}
variable "salt_minion_ssh_password" {}

variable "wait_on" {
  default = []
}

###############################################################################
# Force Inter-Module Dependency
###############################################################################
resource "null_resource" "waited_on" {
  count = "${length(var.wait_on)}"

  provisioner "local-exec" {
    command = "echo Dependency Resolved: ${var.role}--->${element(var.wait_on, count.index)}"
  }
}

###############################################################################
# Migrate Grains File for Specific Server "Role"
###############################################################################
resource "null_resource" "migrate_grains_file" {
  count = "${length(var.salt_minion_ip4v_address_list)}"

  triggers {
    grains_file = "${md5(file("${path.module}/configuration/${var.role}/grains"))}"
  }

  connection {
    user     = "${var.salt_minion_ssh_username}"
    password = "${var.salt_minion_ssh_password}"
    host     = "${element(var.salt_minion_ip4v_address_list, count.index)}"
    type     = "ssh"
  }

  provisioner "file" {
    source      = "${path.module}/configuration/${var.role}/grains"
    destination = "/tmp/grains"
  }

  provisioner "remote-exec" {
    inline = [
      "set -eou pipefail",
      "if [ ! -f /etc/salt ]; then",
      "  sudo mkdir -p /etc/salt",
      "else",
      "  sudo rm /etc/salt/grains",
      "fi",
      "sudo cp -r /tmp/grains /etc/salt/grains",
      "sudo rm /tmp/grains",
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
  value      = "Grains File Successfully Migrated: ${var.role}"
  depends_on = ["null_resource.migrate_grains_files"]
}
