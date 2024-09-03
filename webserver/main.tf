resource "null_resource" "install_tools" {
  provisioner "local-exec" {
    command = <<EOT
      sudo apt-get update
      sudo apt-get install -y apache2
      sudo systemctl start apache2
      sudo systemctl enable apache2

      sudo apt-get update

      #!/bin/bash

      # Update and install dependencies
      sudo apt update -y
      sudo apt upgrade -y
      sudo apt install -y openjdk-11-jdk wget unzip

      # Install Jenkins
      wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
      sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
      sudo apt update
      sudo apt install -y jenkins
      sudo systemctl enable jenkins
      sudo systemctl start jenkins

      # Install SonarQube
      wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.6.1.59531.zip
      sudo unzip sonarqube-9.6.1.59531.zip -d /opt
      sudo mv /opt/sonarqube-9.6.1.59531 /opt/sonarqube
      sudo useradd -r -s /bin/false sonar
      sudo chown -R sonar:sonar /opt/sonarqube
      sudo cp /opt/sonarqube/conf/sonar.properties /opt/sonarqube/conf/sonar.properties.bak
      echo "sonar.jdbc.username=sonar" | sudo tee -a /opt/sonarqube/conf/sonar.properties
      echo "sonar.jdbc.password=sonar" | sudo tee -a /opt/sonarqube/conf/sonar.properties
      sudo cp /opt/sonarqube/bin/linux-x86-64/sonar.sh /usr/local/bin/sonar
      sudo chmod +x /usr/local/bin/sonar
      sudo systemctl start sonarqube
      sudo systemctl enable sonarqube
    EOT
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}
