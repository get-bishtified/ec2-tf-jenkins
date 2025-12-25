pipeline {
  agent any

  parameters {
    booleanParam(
      name: 'APPLY',
      defaultValue: false,
      description: 'Set to TRUE to apply Terraform'
    )
  }

  environment {
    TF_DIR = 'terraform'
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Terraform Init') {
      steps {
        dir(TF_DIR) {
          sh 'terraform init'
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        dir(TF_DIR) {
          sh 'terraform plan'
        }
      }
    }

    stage('Terraform Apply') {
      when {
        expression { params.APPLY }
      }
      steps {
        dir(TF_DIR) {
          sh 'terraform apply -auto-approve'
        }
      }
    }
  }
}
