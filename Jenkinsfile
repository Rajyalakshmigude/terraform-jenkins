pipeline {

    agent any

    environment {
        AWS_REGION = 'us-east-1'
        TF_IN_AUTOMATION = 'true'
    }

    stages {

        stage("git-checkout") {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Rajareddy9704/terraform-jenkins.git'
            }
        }

        stage("Terraform init") {
            steps {
                withCredentials([
                    aws(
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        credentialsId: 'aws-terraform',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {
                    sh '''
                        terraform init
                    '''
                }
            }
        }

        stage("Terraform validate") {
            steps {
                sh '''
                    terraform validate
                '''
            }
        }

        stage("Terraform plan") {
            steps {

                withCredentials([
                    aws(
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        credentialsId: 'aws-terraform',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {

                    sh '''
                        terraform plan -out=tfplan
                    '''
                }
            }

            post {
                success {
                    emailext(
                        subject: 'Terraform Approval Required - ${JOB_NAME} #${BUILD_NUMBER}',
                        body: '''Terraform Plan completed successfully.

Manual approval is required.

Job: ${JOB_NAME}
Build: ${BUILD_NUMBER}

Please open Jenkins and choose ACCEPT or DENY.

Jenkins Build URL:
${BUILD_URL}''',
                        to: 'rajashekarreddybhumireddy@gmail.com'
                    )
                }
            }
        }

        stage("Manual Approval") {
            steps {

                timeout(time: 10, unit: 'MINUTES') {

                    script {

                        def approval = input(
                            message: 'Terraform Plan completed. Choose ACCEPT or DENY.',
                            parameters: [
                                choice(
                                    name: 'ACTION',
                                    choices: ['ACCEPT', 'DENY'],
                                    description: 'Choose ACCEPT to create EC2 or DENY to stop the pipeline'
                                )
                            ]
                        )

                        if (approval == 'DENY') {
                            error('Terraform deployment DENIED by approver.')
                        }

                        echo 'Terraform deployment ACCEPTED.'
                    }
                }
            }
        }

        stage("Terraform apply") {
            steps {

                withCredentials([
                    aws(
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        credentialsId: 'aws-terraform',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                    )
                ]) {

                    sh '''
                        terraform apply -auto-approve tfplan
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
            echo 'Terraform pipeline failed or deployment was denied.'
        }

        aborted {
            echo 'Terraform deployment was stopped.'
        }
    }
}
