pipeline {
    agent any

    stages {
        stage('build') {
            steps {
                echo "Building..."
            }
        }
        stage('test') {
            steps {
                sh test/mkdockerize_test.sh
            }
        }
    }
}