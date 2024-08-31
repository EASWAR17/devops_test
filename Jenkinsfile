pipeline {
    agent any

    environment {
        DEPLOY_SERVER = '127.0.0.1'
        DEPLOY_PATH = '/var/www/html'  // Update to match the deployment path for your static web app
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[url: 'https://github.com/EASWAR17/devops_test.git']]
                ])
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Deploy Static Files') {
            steps {
                script {
                    // Clean the deployment directory
                    sh "ssh ${DEPLOY_SERVER} 'sudo rm -rf ${DEPLOY_PATH}/*'"
                    
                    // Copy the static files from the Jenkins workspace to the deployment directory
                    sh "scp -r ${env.WORKSPACE}/* ${DEPLOY_SERVER}:${DEPLOY_PATH}/"
                    
                    // Restart Apache to apply the new content
                    sh "ssh ${DEPLOY_SERVER} 'sudo systemctl restart apache2'"
                }
            }
        }

        // Optional: Uncomment if you want to perform SonarQube analysis
        // stage('SonarQube Analysis') {
        //     steps {
        //         script {
        //             def scannerHome = tool name: 'sonarserver', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
        //             withSonarQubeEnv('sonarquber') {
        //                 sh "${scannerHome}/bin/sonar-scanner " +
        //                     "-Dsonar.projectKey=test " +
        //                     "-Dsonar.sources=. " +
        //                     "-Dsonar.language=js " +
        //                     "-Dsonar.sourceEncoding=UTF-8"
        //             }
        //         }
        //     }
        // }

        // Optional: Uncomment if you want to check SonarQube Quality Gate
        // stage('Quality Gate') {
        //     steps {
        //         script {
        //             timeout(time: 1, unit: 'MINUTES') {
        //                 def qg = waitForQualityGate()
        //                 if (qg.status != 'OK') {
        //                     error "Pipeline aborted due to quality gate failure: ${qg.status}"
        //                 }
        //             }
        //         }
        //     }
        // }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
