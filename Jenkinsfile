pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[url: 'https://github.com/your-repo.git']]
                ])
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Define the scannerHome path explicitly
                    def scannerHome = tool name: 'Sonarserver', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                    
                    // Run SonarQube analysis
                    withSonarQubeEnv('sonarquber') {
                        bat "${scannerHome}/bin/sonar-scanner.bat " +
                            "-Dsonar.projectKey=test " +
                            "-Dsonar.sources=. " +
                            "-Dsonar.language=js " +
                            "-Dsonar.sourceEncoding=UTF-8"
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                // Wait for SonarQube Quality Gate result
                timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Deployment steps
                }
            }
        }
    }
}
