pipeline {
    agent any

    environment {
        DEPLOY_SERVER = '127.0.0.1'  // Local server address
        DEPLOY_PATH = '/var/www/behance' // Deployment path for Apache
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
                    // Add the host key to known_hosts to avoid verification issues
                    sh "ssh-keyscan -H ${DEPLOY_SERVER} >> ~/.ssh/known_hosts"

                    // Clean the deployment directory
                    sh "ssh -o StrictHostKeyChecking=no ${DEPLOY_SERVER} 'sudo rm -rf ${DEPLOY_PATH}/*'"

                    // Copy the static files from the Jenkins workspace to the deployment directory
                    sh "scp -o StrictHostKeyChecking=no -r ${env.WORKSPACE}/* ${DEPLOY_SERVER}:${DEPLOY_PATH}/"

                    // Restart Apache to apply the new content
                    sh "ssh -o StrictHostKeyChecking=no ${DEPLOY_SERVER} 'sudo systemctl restart apache2'"
                }
    }
}

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
