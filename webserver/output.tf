output "jenkins_status" {
  description = "The status of Jenkins service."
  value       = "Jenkins should be installed and running if no errors occurred."
}

output "sonarqube_status" {
  description = "The status of SonarQube service."
  value       = "SonarQube should be installed and running if no errors occurred."
}