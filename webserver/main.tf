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

  provisioner "file" {
    source      = "path/to/your/local/index.html"  # Local path to your HTML file (relative to your Terraform workspace)
    destination = "/var/www/html/index.html"        # Path on the web server where the HTML file should be placed
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}
