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

    stage('Approval') {
      agent none   // 🔥 CRITICAL FIX
      when {
        not { expression { params.AUTO_APPROVE } }
      }
      steps {
        input message: 'Apply Terraform changes?'
      }
    }

    stage('Terraform Apply') {
      steps {
        dir(TF_DIR) {
          sh 'terraform apply -auto-approve'
        }
      }
    }
  }
}
