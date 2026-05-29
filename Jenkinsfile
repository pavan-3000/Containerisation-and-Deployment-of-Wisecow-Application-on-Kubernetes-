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
                sh 'pip3 install -r requirements.txt'
        sh 'python3 -m pytest'
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