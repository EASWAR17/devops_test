pipeline {
    agent any

    environment {
        DEPLOY_SERVER = '127.0.0.1'  
        DEPLOY_PATH = '/var/www/behance'
        SONARQUBE_URL = 'http://192.168.66.137:9000'
        SONARQUBE_TOKEN = 'squ_1189152129eed4130c75254ca90a97975fc86637'
        PROJECT_KEY = 'test1' 
    }

     triggers {
         pollSCM('H/5 * * * *') // Polls every 5 minutes
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

        
        stage('SonarQube Analysis') {
    steps {
        script {
            def scannerHome = tool name: 'sonarserver', type: 'hudson.plugins.sonar.SonarRunnerInstallation'

            sh "${scannerHome}/bin/sonar-scanner " +
                "-Dsonar.projectKey=test1 " +
                "-Dsonar.sources=. " +
                "-Dsonar.host.url=http://192.168.66.137:9000 " +
                "-Dsonar.token=squ_1189152129eed4130c75254ca90a97975fc86637"
                // "-Dsonar.sourceEncoding=UTF-8 -X"  // Added -X for detailed debug logs
        }
    }
}

        stage('Quality Gate') {
            steps {
                script {
                    // Wait for the SonarQube analysis report and check the Quality Gate status
                    def response = sh(script: "curl -u ${SONARQUBE_TOKEN}: \"${SONARQUBE_URL}/api/qualitygates/project_status?projectKey=${PROJECT_KEY}\"", returnStdout: true).trim()
                    def json = readJSON(text: response)
                    if (json.projectStatus.status != 'OK') {
                        error "Quality gate failed: ${json.projectStatus.status}"
                    } else {
                        echo "Quality gate passed."
                    }
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
