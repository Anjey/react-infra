pipeline{
    agent any
    stages{
        stage ('Prepare source and init vars'){
            agent any
            steps {
            echo 'git pull'
            // sshagent(credentials: ['github-react']) 
            // {
            git branch: '$branch', credentialsId: 'github-react', url: 'https://github.com/Anjey/react-infra.git'
                script {
                    sh 'git submodule update --recursive --init --remote'
                    sh 'git --git-dir="./.git" --work-tree="./" describe --always > ./VERSION.txt'
                    
                }
            }
        }
         stage ('terragrunt plan'){
            agent any
            steps {
                withCredentials([[
                                    $class: 'AmazonWebServicesCredentialsBinding',
                                    credentialsId: "AWS_CREDENTIALS_JENKINS",
                                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                                    ]]) {
                    sshagent(credentials: ['github-react']) 
                                    
                                    {
                                                    sh '''
                    cd ./adudych/us-east-2/dev/cloudfront && terragrunt init && terragrunt plan
                    '''
                }
            }
        }
    }
    stage ('terragrunt apply'){
            agent any
            steps {
                withCredentials([[
                                    $class: 'AmazonWebServicesCredentialsBinding',
                                    credentialsId: "AWS_CREDENTIALS_JENKINS",
                                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                                    ]]) {
                    sshagent(credentials: ['github-react']) 
                                    
                                    {
                                                    sh '''
                    cd ./adudych/us-east-2/dev/cloudfront && terragrunt apply -auto-approve
                    '''
                }
            }
        }
    }     
}
          
    post{
        
        cleanup{
            echo "cleanup"
            cleanWs()
            dir("${env.WORKSPACE}@tmp") {
      deleteDir()
    }
        }
        success{
            echo "========pipeline executed successfully ========"
            
        }
        failure{
            echo "========pipeline execution failed========"
        }
    }

}