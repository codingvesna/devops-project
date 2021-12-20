pipeline {
    environment {
        registry = ""
        registryCredential = ''
        myImage = ''
     
    }
    agent any
    tools {
        maven 'M3'
    }
    stages {
        stage('code') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/ecs-demo']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/codingvesna/devops-project.git']]])
            }
        }

        stage('build') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('test') {
            steps {
                sh 'mvn test -DskipTests'
            }
        }

        stage('package') {
            steps {
                script {
                  sh 'mvn package -DskipTests'
                }
                archiveArtifacts artifacts: 'target/*.war', followSymlinks: false
            }
        }
  
        stage('deploy') {
              steps {
                script {
                  docker.withRegistry(
                    '341495406858.dkr.ecr.eu-west-1.amazonaws.com/java-ecs',
                    'ecr:eu-west-1:aws_credentials'
                    ) {
                      myImage = docker.build('java-ecs')
                      myImage.push()
                     }
                 }
              }
       }

        
        

    }
}
