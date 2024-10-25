pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        dir('backend') {  // Change to the 'backend' directory
          sh '''#!/bin/bash
          python3.9 -m venv venv
          source venv/bin/activate
          pip install pip --upgrade
          pip install -r requirements.txt
          '''
        }
      }
    }
    stage('Test') {
      steps {
        dir('backend') {  // Change to the 'backend' directory
          sh '''#!/bin/bash
          source venv/bin/activate
          export PYTHONPATH=$(pwd)
          pip install pytest-django
          python manage.py makemigrations
          python manage.py migrate
          pytest account/tests.py --verbose --junit-xml test-reports/results.xml
          ''' 
        }
      }
    }
    stage('Init') {
      steps {
        dir('Terraform') {
          sh 'terraform init' 
        }
      }
    } 
    stage('Plan') {
      steps {
        withCredentials([string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'), 
                          string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key'),
                          string(credentialsId: 'RDS_PASSWORD', variable: 'db_password')]) {
          dir('Terraform') {
            sh 'terraform plan -out plan.tfplan -var="aws_access_key=${aws_access_key}" -var="aws_secret_key=${aws_secret_key}" -var="db_password=${db_password}"' 
          }
        }
      }     
    }
    stage('Apply') {
      steps {
        dir('Terraform') {
          sh 'terraform apply plan.tfplan' 
        }
      }  
    }       
  }
}
