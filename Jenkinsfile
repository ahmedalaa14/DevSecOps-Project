pipeline {
    agent any 

    tools {

        nodejs 'nodejs'
    }
    environment {

        SCANNER_HOME = tool name: 'sonarqube'
        Docker_Credential = "DockerHub-Credentail"                                   

    }

    stages {
        stage ("workspace cleanup") {
            steps {
                cleanWs()
            }
        }

        stage ('Checkout') {
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
        stage ('SonarQube analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=netflix-app \
                        -Dsonar.projectKey=netflix-app \
                    '''
                }
            }
        }
        
        stage('Trivy Scan') {
            steps {
                sh ' trivy fs . > trivy-report.txt ' 
            }
        }
        stage ('Docker Image Build and Run') {
            steps {
                sh '''
                docker build -t ahmedalaa14/netflix-app .
                docker image ls
                docker run  -d -p 8081:80 --name netflix ahmedalaa14/netflix-app
                '''

            }
        }  
        stage ('Scan Docker Image') {
            steps {
                  sh "trivy image ahmedalaa14/netflix-app > trivyimage.txt" 
            }
        }
            
            
    }
}
