pipeline {
    environment {
        registry = "vesnam/java-ecs"
        registryCredential = 'dockerhub'
        dockerImage = ''
        container = 'java-ecs'
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
                sh 'mvn test'
            }
        }

        stage('package') {
            steps {
                script {
                  sh 'mvn package'
                }
                archiveArtifacts artifacts: 'target/*.war', followSymlinks: false
            }
        }

        stage('build docker image'){
            steps  {
                script {
                //     sh 'docker build -t vesnam/webapp-pipeline .'
                    dockerImage = docker.build registry
                }

            }

        }
        stage('deploy image') {
            steps{
                script {
                    docker.withRegistry( 'https://registry.hub.docker.com/', registryCredential ) {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('run container') {
            steps {
                sh 'docker-compose up -d --build'
            }
        }

        stage('cleanup') {
            steps{
//                 sh 'docker stop $container'
//                 sh 'docker rm $container'
                sh 'docker rmi $registry'
            }
        }


    }
}
