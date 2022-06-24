pipeline {
    agent any
    environment {
        DOCKER_USER     = credentails('docker-username')
        DOCKER_PASSWORD = credentails('docker-password')
    }
    stages {
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
                sh 'docker build -t test-image:1.0 .' 
            }
        }

        stage('TAG Docker Image') {
            steps {
                echo '=== Tagging petclinic Docker Image ==='
                sh 'sudo docker tag test-image $DOCKER_USER/slawal-image:1.0'
            }
        }
        stage('Push Docker Image to docker hub') {
            steps {
                echo '=== Pushing Petclinic Docker Image ==='
                sh 'sudo docker push $DOCKER_USER/test-image:1.0'
            }
        }
        stage('Deploy to K8Ss') {
            steps {
               sh ' bash && export KUBECONFIG=/var/lib/jenkins/admin.conf && kubectl apply -f deployment.yaml'
            }
        }
        stage ('Run Docker on k8s') {
	      steps{
	        	sshagent(credentials : ['k8s-server-Private']) {
		         sh 'ssh -o StrictHostKeyChecking=no ec2-user@3.145.58.235 "sudo docker login --username $DOCKER_USER --password $DOCKER_PASSWORD && kubectl apply -f petclinic.yaml"'
		        }
	        }
    	}
    }
}
