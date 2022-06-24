pipeline {
        agent any
    environment {
        DOCKER_USER     = credentials('docker-username')
        DOCKER_PASSWORD = credentials('docker-password') 
    } 
        tools {
                maven 'maven'
        }
        
    stages {
        stage('pullsourceCode'){
            steps{ 
                git branch: 'main', credentialsId: '1308e8bf-a4dd-4e14-a528-0a63b4496939', url: 'https://github.com/sundaylawal/spring-petclinic.git'
            }
        }
    
        stage('BuildCode'){
            steps{ 
                sh 'mvn install -DskipTests=true'
            }
        }

        stage('Login to Docker HUB') {
            steps {
                echo '===Login to docker hub ==='
                sh 'sudo docker login --username $DOCKER_USER --password $DOCKER_PASSWORD'
            }
        }

        stage('Building Docker Image') { 
            steps {
                echo '=== Creating Docker image==='
                sh 'docker build -t slawal-image:1.0 .' 
            }
        }

        stage('TAG Docker Image') {
            steps {
                echo '=== Tagging petclinic Docker Image ==='
                sh 'sudo docker tag slawal-image $DOCKER_USER/slawal-image:1.0'
            }
        }
        stage('Push Docker Image to docker hub') {
            steps {
                echo '=== Pushing Petclinic Docker Image ==='
                sh 'sudo docker push $DOCKER_USER/slawal-image:1.0'
            }
        }
        
        stage ('Run Docker on k8s') {
	      steps{
	        	sshagent(['k8s-server-Private']) {
		         sh 'ssh -o StrictHostKeyChecking=no ec2-user@3.145.58.235 "sudo docker login --username $DOCKER_USER --password $DOCKER_PASSWORD && kubectl apply -f petclinic.yaml"'
		        }
	        }
    	}
    }
}
