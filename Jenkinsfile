pipeline {
    agent any 

    tools {

        nodejs 'nodejs'
    }
    environment {

        SCANNER_HOME = tool name: 'sonarqube'
    }

    stages {
        stage ("workspace cleanup") {
            steps {
                cleanWs()
            }
        }

        stage {'Checkout'} {
            steps {
                      git branch: 'main', url: 'https://github.com/ahmedalaa14/DevSecOps-Project'
            }
        }

        stage ('Install dependencies') {
            steps {
                sh 'npm install'
            }
        }
        stage ('build') {
            steps {
                sh 'npm run build'
            }
        }
       
    }

}