pipeline {
    agent any
	
	environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout code from GitHub repository
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url:'https://github.com/PaaQuarme/Demo-Jen.git',
                    ]]
                ])
            }
        }
        stage('Terraform Init') {
            steps {
                // Initialize Terraform
                bat 'terraform init'
            }
        }
        stage ("Terraform Action") {
            steps {
                echo "Terraform action is --> ${action}"
                bat "terraform ${action} -auto-approve"
            }
        }
    }
}
