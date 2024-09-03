provider "local" {}

module "webserver" {
  source = "./webserver"

  # jenkins_version   = "2.319.1"
  # sonarqube_version = "9.7.1.62043"
}

output "jenkins_status" {
  value = module.webserver.jenkins_status
}

output "sonarqube_status" {
  value = module.webserver.sonarqube_status
}
