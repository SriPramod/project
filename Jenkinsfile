pipeline {
    environment {
           registry = "sripramod11/myproject"
           registryCredential = 'docker-hub'
           dockerImage = ''
    }
    agent any
    stages{


          stage("Ansible"){
            steps{
                node('ansible-label')
                 {
                    git 'https://github.com/SriPramod/project.git'
                    ansiblePlaybook credentialsId: 'private-key', disableHostKeyChecking: true, installation: 'ansible', inventory: 'ansible.ini', playbook: 'ansible.yml'
                 }
                }
              }

 
         stage("SCM"){
            steps{
                   node('scm-label') 
                   {
                    git 'https://github.com/SriPramod/project.git'
                   }
                 }
               }
            
         stage("SonarQube")
         {
            steps{
                node('sonar-label')
                  {
                    git 'https://github.com/SriPramod/project.git'
                    script{  
                     def scannerHome = tool 'SonarQube Scanner';
                   withSonarQubeEnv('sonarqube') { 
                       sh "${scannerHome}/bin/sonar-scanner \
                       -D sonar.login=admin \
                       -D sonar.password=admin \
                       -D sonar.projectKey=sonartest1 \
                       -D sonar.sources=. \
                       -D sonar.exclusions=vendor/**,resource/**,**/*.java \
                       -D sonar.host.url=http://172.31.28.172:9000/" }
                   }
                   }
                 }
        }
         
         stage("Docker")
         {
             steps{
                 node('docker-label')   
                 {
                   git 'https://github.com/SriPramod/project.git'
                   sh 'mvn package' 
                   echo 'Starting to build docker image'
                script{
                       dockerImage = docker.build registry + ":$BUILD_NUMBER"  
                       docker.withRegistry( '',registryCredential ) {  
                       dockerImage.push("$BUILD_NUMBER")
                       dockerImage.push('latest') }
                       sh "docker rmi -f $registry:$BUILD_NUMBER"
                       sh "docker rmi $registry:latest"
                       }	
                 }
             }
         }
    }
}
