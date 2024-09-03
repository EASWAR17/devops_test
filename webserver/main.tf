resource "null_resource" "install_tools" {
  provisioner "local-exec" {
    command = <<-EOF

      #apache server
      sudo apt-get update
      sudo apt-get install -y apache2
      sudo systemctl start apache2
      sudo systemctl enable apache2

      #jenkins
      # Update package lists
      sudo apt-get update

      # Install prerequisites
      sudo apt-get install -y wget gnupg

      # Add Jenkins repository key
      wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -

      # Add Jenkins repository
      sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

      # Update package lists again after adding the new repository
      sudo apt-get update

      # Install Jenkins
      sudo apt-get install -y jenkins=${var.jenkins_version}

      # Enable and start Jenkins service
      sudo systemctl enable jenkins
      sudo systemctl start jenkins

      sudo apt-get update
      # Install SonarQube
      wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.5.1.90531.zip -O /opt/sonarqube.zip
      sudo apt-get install -y zip
      unzip /opt/sonarqube.zip -d /opt/
      sudo mv /opt/sonarqube-10.5.1.90531 /opt/sonarqube
      sudo chown -R ubuntu:ubuntu /opt/sonarqube
      
      # Create and configure SonarQube systemd service
      sudo tee /etc/systemd/system/sonarqube.service > /dev/null <<EOL
      [Unit]
      Description=SonarQube service
      After=network.target
      
      [Service]
      Type=forking
      User=ubuntu
      Group=ubuntu
      ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
      ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
      Restart=on-failure
      
      [Install]
      WantedBy=multi-user.target
      EOL
      
      sudo systemctl daemon-reload
      sudo systemctl start sonarqube
      sudo systemctl enable sonarqube
      
      # Install SonarScanner
      wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-6.1.0.4477-linux-x64.zip -O /opt/sonar-scanner.zip
      unzip /opt/sonar-scanner.zip -d /opt
      echo "export PATH=\$PATH:/opt/sonar-scanner-6.1.0.4477-linux-x64/bin" >> /home/ubuntu/.bashrc
      echo "export SONAR_SCANNER_HOME=/opt/sonar-scanner-6.1.0.4477-linux-x64" >> /home/ubuntu/.bashrc
      source /home/ubuntu/.bashrc
      
      # Clean up
      rm /opt/sonar-scanner.zip
      rm /opt/sonarqube.zip
      EOF
  }
}
