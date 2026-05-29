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
                    sh 'pip install -r requirements.txt'
                    sh 'python -m pytest'
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