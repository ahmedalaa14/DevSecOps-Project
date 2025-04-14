pipeline {
    agent any 

    tools {
        nodejs 'nodejs'
    }
    environment {
        SCANNER_HOME = tool name: 'sonarqube'
        Docker_Credential = "DockerHub-Credentail"  
        kubectl_path = "/usr/local/bin/kubectl"                                  
    }

    stages {
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

        stage('Push Docker Image to DockerHub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "DockerHub-Credentail", usernameVariable:"username", passwordVariable:"password")]) {
                        sh '''
                        echo "${password}" | docker login -u "${username}" --password-stdin
                        docker push ahmedalaa14/netflix-app
                        '''
                    }
                }
            }
        }

        stage('Deploy to kubernetes') {
            steps {
                script {
                    sh ' echo "hello" '
                   // dir('kubernetes') {
                    //    withCredentials([file(credentialsId: 'kubeconfig-credential-id', variable: 'KUBECONFIG')])
                    //    sh 'kubectl apply -f deployment.yml'
                    //    sh 'kubectl apply -f service.yml'
                   // }   
                }
            }
        }
    }

    post {
        always {
            emailext attachLog: true,
                subject: "'${currentBuild.result}' Build Notification",
                body: """<p>Project: ${env.JOB_NAME}</p>
                         <p>Build Number: ${env.BUILD_NUMBER}</p>
                         <p>URL: <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>""",
                to: 'ahmedmokhtar14600@gmail.com'
        }
    }
}