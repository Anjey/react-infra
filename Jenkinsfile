pipeline{
    agent any
    parameters {
        string(defaultValue: "dev", name: 'BRANCH_DEV')
        string(defaultValue: "stage", name: 'BRANCH_STAGE')
        string(defaultValue: "main", name: 'BRANCH_PROD')
    }

    // environment {
    //     env=getEnvironment(branch, env.BRANCH_DEV, env.BRANCH_STAGE, env.BRANCH_PROD)
    //     AWS_REGION=getRegion(branch, env.BRANCH_DEV, env.BRANCH_PROD)
    // }


    stages{
        stage('Checkout') {
            steps {
                deleteDir()
                checkout scm
                // sh "printenv"
            }
        }

        stage("Env Variables") {
            steps {
                sh "printenv"
            }
        }
        
        
        stage("Prod") {
            steps {
                echo "${BRANCH_PROD}"
            }
        }
        stage("dev") {
            steps {
                echo "${BRANCH_DEV}"
            }
        }

         stage ('terragrunt plan'){
            when {
                anyOf {
                    branch "${BRANCH_DEV}"
                    branch "${BRANCH_PROD}"
                    branch "${BRANCH_STAGE}"
                }
            }
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
                    cd ./adudych/us-east-2/${env}/cloudfront && terragrunt init && terragrunt plan
                    '''
                }
            }
        }
    }
    stage ('terragrunt apply'){
            when {
                anyOf {
                    branch "${BRANCH_DEV}"
                    branch "${BRANCH_PROD}"
                    branch "${BRANCH_STAGE}"
                }
            }
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
                    cd ./adudych/us-east-2/${env}/cloudfront && terragrunt apply -auto-approve
                    '''
                }
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



def getEnvironment(String branch, String BRANCH_DEV, String BRANCH_STAGE, String BRANCH_PROD) {
        if (branch == BRANCH_PROD) {
            return "prod"
        }
        if (branch == BRANCH_STAGE) {
            return "stage"
        }
        if (branch == BRANCH_DEV) {
            return "dev"
        }
        return "${branch}"
    }

def getRegion(String branchOrTag, String BRANCH_DEV, String BRANCH_PROD) {
    if (branchOrTag == BRANCH_PROD) {
    return "us-east-1"
    }
  if (branchOrTag == BRANCH_DEV) {
    return "us-east-2"
    }
}