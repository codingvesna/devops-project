pipeline {
    environment {
		dockerImage = ""
	        aws_account_id = "341495406858"
		aws_default_region = "eu-west-1"
		image_repo_name = "java-ecs"
		image_tag = "latest"
        registry = "${aws_account_id}.dkr.ecr.${aws_default_region}.amazonaws.com/${image_repo_name}" 
	    
    }
    agent any
    tools {
        maven 'M3'
    }
    stages {
	
		stage('aws login'){
			steps {
				alias aws='docker run --rm -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY amazon/aws-cli'
				sh "aws ecr get-login-password --region ${aws_default_region} | docker login --username AWS --password-stdin ${aws_account_id}.dkr.ecr.${aws_default_region}"
			}
		}
 
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
        
            // Building Docker image
        stage('Building image') {
          steps{
            script {
              dockerImage = docker.build "${image_repo_name}:${image_tag}"
            }
          }
        }
  
        stage('push to AWS ECR') {
              steps {
                script {
                  sh "docker tag ${image_repo_name}:${image_tag} ${registry}:$image_tag"
                  sh "docker push ${aws }.dkr.ecr.${aws_default_region}.amazonaws.com/${image_repo_name}:${image_tag}"
                }
             }
	}

        
        

    }
}
