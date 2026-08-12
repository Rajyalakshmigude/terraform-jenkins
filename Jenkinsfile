pipeline {

    agent any

    environment {
        AWS_REGION = 'us-east-1'
        AWS_DEFAULT_REGION = 'us-east-1'
        TF_IN_AUTOMATION = 'true'
    }

    stages {

        stage("Git Checkout") {
            steps {

                git branch: 'main',
                    url: 'https://github.com/Rajareddy9704/terraform-jenkins.git'
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

            post {

                success {

                    emailext(
                        subject: "Terraform Approval Required - ${env.JOB_NAME} #${env.BUILD_NUMBER}",

                        body: """Hello,

Terraform Plan completed successfully.

Manual approval is required before Terraform Apply.

Job: ${env.JOB_NAME}
Build Number: ${env.BUILD_NUMBER}

Please open Jenkins and choose ACCEPT or DENY.

Jenkins Build URL:
${env.BUILD_URL}

Terraform Apply will execute only after ACCEPT.

Thanks,
Jenkins
""",

                        to: 'rajashekarreddybhumireddy@gmail.com'
                    )
                }
            }
        }

        stage("Manual Approval") {

            steps {

                timeout(
                    time: 10,
                    unit: 'MINUTES'
                ) {

                    script {

                        def approval = input(
                            message: 'Terraform Plan completed. Do you want to continue?',
                            ok: 'Submit',

                            parameters: [
                                choice(
                                    name: 'ACTION',
                                    choices: ['ACCEPT', 'DENY'],
                                    description: 'Choose ACCEPT to create EC2 or DENY to stop the pipeline'
                                )
                            ]
                        )

                        if (approval == 'DENY') {

                            error(
                                'Terraform deployment DENIED by approver.'
                            )

                        } else {

                            echo 'Terraform deployment ACCEPTED.'
                        }
                    }
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

            echo 'Terraform pipeline failed or deployment was denied.'
        }

        aborted {

            echo 'Terraform deployment was stopped.'
        }
    }
}
