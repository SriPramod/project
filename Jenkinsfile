pipeline {
    environment {
           registry = "patrautpal80/myproject"
           registryCredential = 'docker-hub'
           dockerImage = ''
    }
    agent any
    stages{


          stage("Ansible"){
            steps{
                node('ansible-label')
                 {
                    git 'https://github.com/patra1980/project.git'
                    ansiblePlaybook credentialsId: 'private-key', disableHostKeyChecking: true, installation: 'ansible', inventory: 'aws.ini', playbook: 'install6.yml'
                 }
                }
              }

 
         stage("SCM"){
            steps{
                node('scm-node-label') 
                 {
                    git 'https://github.com/patra1980/project.git'
                 }
                }
              }
            
         stage("SonarQube")
         {
            steps{
                node('sonarserver')
                  {
                    script{  
                     def scannerHome = tool 'SonarQube Scanner';
                   withSonarQubeEnv('sonarqube') { 
                       sh "${scannerHome}/bin/sonar-scanner \
                       -D sonar.login=admin \
                       -D sonar.password=admin \
                       -D sonar.projectKey=sonarqubetest \
                       -D sonar.sources=. \
                       -D sonar.exclusions=vendor/**,resource/**,**/*.java \
                       -D sonar.host.url=http://172.31.78.187:9000/" }
                   }
                   }
                 }
        }
         
         stage("docker")
         {
             steps{
                 node('dockerserver')   
                 {
                   script{
                       dockerImage = docker.build registry + ":$BUILD_NUMBER"  
                       docker.withRegistry( 'https://registry.hub.docker.com', registryCredential ) {   
                           dockerImage.push() }
                       sh "docker rmi -f $registry:$BUILD_NUMBER"
                         }	
                 }
             }
         }
    }
}
