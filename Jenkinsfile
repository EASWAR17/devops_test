
pipeline {
    agent any

    environment {
        DEPLOY_SERVER = '127.0.0.1'
        DEPLOY_PATH = '/var/www/behance'
    }
     // triggers {
     //     pollSCM('H/2 * * * *') // Polls every 5 minutes
     // }

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[url: 'https://github.com/EASWAR17/devops_test.git']]
                ])
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Define the scannerHome path explicitly
                    def scannerHome = tool name: 'sonarserver', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                    
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
                script {
                    
                    // def qg = waitForQualityGate()
                    // if (qg.status != 'OK') {
                    //     error "SonarQube Quality Gate failed: ${qg.status}"
                    //                 }
                    sleep(60)
                    timeout(time: 1, unit: 'MINUTES') {
                    def qg = waitForQualityGate()
                    print "Finished waiting"
                    if (qg.status != 'OK') {
                        error "Pipeline aborted due to quality gate failure: ${qg.status}"
                    }
}  
                }
            }
        }

        

        stage('Deploy') {
            steps {
                script {
                    // Remove the existing files
                    bat "del /S /Q ${DEPLOY_PATH}\\*"
                    
                    // Copy the new files from the repository to the deployment folder
                    bat "xcopy /E /I /Y ${env.WORKSPACE} ${DEPLOY_PATH}"
                }
            }
        }
    }
}