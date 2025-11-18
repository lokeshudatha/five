pipeline {  
    agent any  
    environment {  
        DOCKERHUB_CREDENTIALS = credentials('docker-creds')
    }  
    stages {  
        stage('checkout') {  
            steps {  
                echo "*********** cloning the code **********"  
                sh 'rm -rf five || true'  
                sh 'git clone https://github.com/lokeshudatha/five.git' 
            }  
        }
         stage('Docker image build') {  
            steps {  
                echo "********** building is done ************"  
                dir('five') {  
                    sh 'docker build -t p:v .'  
                }  
            }  
        }
        stage('Docker image build') {  
            steps {  
                echo "********** building is done ************"  
                dir('five') {  
                    sh 'docker tag p:v 9515524259/python:v1'  
                }  
            }  
        }
          stage('Push to Docker Hub') {  
            steps {  
                sh """  
                docker login -u ${DOCKERHUB_CREDENTIALS_USR} -p ${DOCKERHUB_CREDENTIALS_PSW}  
                docker push 9515524259/python:v1 
                """  
            }  
        }
        
        stage('vm creation using Terraform') {
            steps {
                echo "********** VM creation is done ************"
                dir('/var/lib/jenkins/workspace/five') {
                    sh 'git pull origin main'
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }
        stage('Ansible deployment') {
            steps {
                echo "********** Ansible deployment is done ************"
                dir('/var/lib/jenkins/workspace/five') {
                    sh 'ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i /var/lib/jenkins/workspace/ip.txt playbook.yaml --private-key=/var/lib/jenkins/.ssh/id_ed25519 '
                }
            }
        }
    }  
}
