pipeline {
    agent any

    stages {
        stage('build') {
            steps {
                sh "docker build --rm . -t mkdocs"
            }
        }
        stage('test') {
            steps {
                echo "Testing..."
            }
        }
    }
}