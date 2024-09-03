variable "jenkins_version" {
  description = "The version of Jenkins to install"
  type        = string
  default     = "2.462.1"  
}

variable "sonarqube_version" {
  description = "The version of SonarQube to install."
  type        = string
  default     = "10.4.1.88267"
}
