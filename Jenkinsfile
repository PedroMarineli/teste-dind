pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                script {
                    docker.withRegistry('', '') {
                        def testImage = docker.build("test-image", ".")
                        testImage.inside {
                            sh 'echo "Funcionou!!"'
                        }
                    }
                }
            }
        }
    }
}
