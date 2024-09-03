resource "null_resource" "install_tools" {
  provisioner "local-exec" {
    command = <<EOT
      sudo apt-get update
      sudo apt-get install -y apache2
      sudo systemctl start apache2
      sudo systemctl enable apache2

      sudo apt-get update

      # Check if Jenkins is already installed
      if ! dpkg -l | grep -q jenkins; then
        echo "Jenkins not found. Installing Jenkins..."

        # Install Jenkins
        sudo apt-get install -y openjdk-11-jdk
        wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
        sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary > /etc/apt/sources.list.d/jenkins.list'
        sudo apt-get update
        sudo apt-get install -y jenkins=${var.jenkins_version}
        sudo systemctl start jenkins
        sudo systemctl enable jenkins
      else
        echo "Jenkins is already installed."
      fi

      if [ ! -d /opt/sonarqube ]; then
        echo "SonarQube not found. Installing SonarQube..."

        # Install SonarQube
        sudo apt-get install -y wget unzip
        wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${var.sonarqube_version}.zip
        unzip sonarqube-${var.sonarqube_version}.zip
        sudo mv sonarqube-${var.sonarqube_version} /opt/sonarqube
        sudo useradd --system --home /opt/sonarqube sonarqube
        sudo chown -R sonarqube: /opt/sonarqube

        # Configure SonarQube
        sudo tee /etc/systemd/system/sonarqube.service <<EOF
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=simple
User=sonarqube
Group=sonarqube
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

        # Start and enable SonarQube
        sudo systemctl daemon-reload
        sudo systemctl start sonarqube
        sudo systemctl enable sonarqube
      else
        echo "SonarQube is already installed."
      fi
    EOT
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}
