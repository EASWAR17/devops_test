pipeline {
    agent any

    environment {
        DEPLOY_SERVER = '127.0.0.1'
        DEPLOY_PATH = '/var/www/behance'
    }
    
    // Uncomment this if you want to enable SCM polling
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

        // Uncomment and configure SonarQube analysis if needed
        // stage('SonarQube Analysis') {
        //     steps {
        //         script {
        //             // Define the scannerHome path explicitly
        //             def scannerHome = tool name: 'sonarserver', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                    
        //             // Run SonarQube analysis
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

        // Uncomment and configure Quality Gate if needed
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

        stage('Deploy') {
            steps {
                script {
                    // Remove the existing files
                    sh "rm -rf ${DEPLOY_PATH}/*"
                    
                    // Copy the new files from the repository to the deployment folder
                    sh "cp -r ${env.WORKSPACE}/* ${DEPLOY_PATH}/"
                }
            }
        }
    }
}
