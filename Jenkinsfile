pipeline {
    environment {
           registry = "SriPramod/project"
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
                    script{  
                     def scannerHome = tool 'SonarQube Scanner';
                   withSonarQubeEnv('sonarqube') { 
                       sh "${scannerHome}/bin/sonar-scanner \
                       -D sonar.login=admin \
                       -D sonar.password=admin123 \
                       -D sonar.projectKey=sonarqubetest \
                       -D sonar.sources=. \
                       -D sonar.exclusions=vendor/**,resource/**,**/*.java \
                       -D sonar.host.url=http://172.31.69.215:9000/" }
                   }
                   }
                 }
        }
         
         stage("Docker")
         {
             steps{
                 node('docker-label')   
                 {
                     script{
                       git 'https://github.com/SriPramod/project.git'
                       sh 'mvn package'
                       dockerImage = docker.build registry + ":$BUILD_NUMBER"  
                       docker.withRegistry( 'https://registry.hub.docker.com', registryCredential ) {   
                           dockerImage.push() }
                       sh "docker rmi -f $registry:$BUILD_NUMBER"
                       sh 'mvn clean package'
                         }	
                 }
             }
         }
    }
}
