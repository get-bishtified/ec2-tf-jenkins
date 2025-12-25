pipeline {
  agent { label 'master' }
  environment {
    TF_DIR = 'terraform'
  }
  parameters {
    booleanParam(name: 'AUTO_APPROVE', defaultValue: false, description: 'If true, terraform apply runs with -auto-approve')
    string(name: 'AWS_REGION', defaultValue: 'ap-south-1', description: 'AWS region to create resources in')
  }
  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Terraform Init & Validate') {
      steps {
        dir(env.TF_DIR) {
          withCredentials([usernamePassword(credentialsId: 'aws-creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
            sh 'terraform --version'
            sh 'terraform init -input=false'
            sh 'terraform fmt -diff -write=true'
            sh 'terraform validate || true'
          }
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        dir(env.TF_DIR) {
          withCredentials([usernamePassword(credentialsId: 'aws-creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
            sh 'terraform plan -out=tfplan -input=false -var "aws_region=${params.AWS_REGION}"'
            sh 'terraform show -json tfplan > plan.json || true'
            archiveArtifacts artifacts: 'terraform/plan.json', allowEmptyArchive: true
          }
        }
      }
    }

    stage('Approval') {
      when { expression { return !params.AUTO_APPROVE } }
      steps {
        input message: 'Apply Terraform changes to AWS?', ok: 'Apply'
      }
    }

    stage('Terraform Apply') {
      steps {
        dir(env.TF_DIR) {
          withCredentials([usernamePassword(credentialsId: 'aws-creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
            script {
              if (params.AUTO_APPROVE) {
                sh 'terraform apply -input=false -auto-approve tfplan'
              } else {
                sh 'terraform apply -input=false tfplan'
              }
            }
          }
        }
      }
    }

    stage('Outputs') {
      steps {
        dir(env.TF_DIR) {
          sh 'terraform output -json > outputs.json || true'
          archiveArtifacts artifacts: 'terraform/outputs.json', allowEmptyArchive: true
        }
      }
    }
  }

  post {
    always {
      echo 'Terraform pipeline completed.'
    }
  }
} 
