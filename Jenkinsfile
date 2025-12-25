pipeline {
  agent any

  parameters {
    booleanParam(
      name: 'AUTO_APPROVE',
      defaultValue: false,
      description: 'Run terraform apply with -auto-approve'
    )
  }

  environment {
    TF_DIR     = 'terraform'
    AWS_REGION = 'ap-south-1'
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Terraform Init') {
      steps {
        dir("${TF_DIR}") {
          sh 'terraform --version'
          sh 'terraform init'
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        dir("${TF_DIR}") {
          sh 'terraform plan'
        }
      }
    }

    stage('Approval') {
      when {
        not {
          expression { params.AUTO_APPROVE }
        }
      }
      steps {
        input message: 'Apply Terraform changes?'
      }
    }

    stage('Terraform Apply') {
      steps {
        dir("${TF_DIR}") {
          sh 'terraform apply ${AUTO_APPROVE ? "-auto-approve" : ""}'
        }
      }
    }
  }

  post {
    success {
      echo 'Terraform pipeline completed successfully.'
    }
    failure {
      echo 'Terraform pipeline failed.'
    }
  }
}
