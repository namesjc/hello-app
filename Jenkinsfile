pipeline {

  environment {
    imagename = 'adiachan/hello-app'
    def imageTag = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
  }

  options {
    ansiColor('xterm')
  }

  agent {
    kubernetes {
      yamlFile 'builder.yaml'
    }
  }

  stages {

    stage('Kaniko Build & Push Image') {
      steps {
        container('kaniko') {
          script {
            sh '''
            /kaniko/executor --dockerfile `pwd`/Dockerfile \
                             --context `pwd` \
                             --destination=${imagename}:${imageTag}
            '''
          }
        }
      }
    }

    stage('Deploy DEV') {
      environment {
        GIT_CREDS = credentials('github')
      }
      steps {
        container('tools') {
          sh('git clone https://$GIT_CREDS_USR:$GIT_CREDS_PSW@github.com/namesjc/argocd_demo.git')
          sh("git config --global user.email 'adiachan@outlook.com'")

          dir("argocd_demo") {
            sh("cd ./overlays/dev && kustomize edit set image adiachan/hello-app:${imageTag}")
            sh("git commit -am 'Publish new version' && git push || echo 'no changes'")
          }
        }
      }
    }

  }
}
