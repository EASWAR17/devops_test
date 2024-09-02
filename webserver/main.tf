# Define a resource to install and configure Apache
resource "null_resource" "apache_setup" {
  provisioner "local-exec" {
    command = <<EOT
      sudo apt-get update
      sudo apt-get install -y apache2
      sudo systemctl start apache2
      sudo systemctl enable apache2
    EOT
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}
