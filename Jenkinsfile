pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                catchError {
                    sh 'pip install -r requirements.txt' // Changed python3 -m pip to pip
                    sh 'python3 -m pytest'
                }
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
            }
        }

        stage('Deploy') {
            when { branch 'main' }
            steps {
                echo 'Deploying to production...'
            }
        }
    }

    post {
        success { echo 'Pipeline succeeded!' }
        failure  { echo 'Pipeline failed!' }
    }
}