variable "jenkins_version" {
  description = "The version of Jenkins to install."
  type        = string
  default     = "2.319.1"
}

variable "sonarqube_version" {
  description = "The version of SonarQube to install."
  type        = string
  default     = "9.7.1.62043"
}