pipeline {

    agent any

    environment {
        AWS_REGION = 'ap-south-2'
        AWS_DEFAULT_REGION = 'ap-south-2'
        TF_IN_AUTOMATION = 'true'
    }

    stages {

        stage("Git Checkout") {
            steps {

                
                git branch: 'main', url: 'https://github.com/Rajyalakshmigude/terraform-jenkins.git'
            }
        }

        stage("Terraform Init") {
            steps {

                withCredentials([
                    aws(
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        credentialsId: 'aws-terraform',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {

                    sh '''
                        terraform init -input=false
                    '''
                }
            }
        }

        stage("Terraform Validate") {
            steps {

                sh '''
                    terraform validate
                '''
            }
        }

        stage("Terraform Plan") {
            steps {

                withCredentials([
                    aws(
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        credentialsId: 'aws-terraform',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {

                    sh '''
                        terraform plan -input=false -out=tfplan
                    '''
                }
            }
        }

        stage("Terraform Apply") {
            steps {

                withCredentials([
                    aws(
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        credentialsId: 'aws-terraform',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {

                    sh '''
                        terraform apply -input=false -auto-approve tfplan
                    '''
                }
            }
        }
    }

    post {

        success {

            echo 'Terraform infrastructure successfully created.'
        }

        failure {

            echo 'Terraform pipeline failed.'
        }

        aborted {

            echo 'Terraform deployment was stopped.'
        }
    }
}
