# Assuming you want to install Apache and deploy an existing file

# Define a resource to ensure the web server is set up
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
    source      = "/var/www/behance/index.html"     # Path to the existing HTML file on the local machine
    destination = "/var/www/html/index.html"       # Path where the file should be placed on the web server
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}
