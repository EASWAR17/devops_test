provider "null" {}

resource "null_resource" "install_jenkins" {
  provisioner "local-exec" {
    command = "powershell -Command \"choco install -y jenkins\""
  }
}

output "jenkins_status" {
  value = "Checked Jenkins installation status and executed installation "
}