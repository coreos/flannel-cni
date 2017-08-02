pipeline {
  agent {
     label 'coreos && !rkt-fly'
  }

  stages {
    stage('build-image') {
      when {
        branch 'master'
      }
      environment {
        QUAY = credentials('174f0169-803f-4840-8e07-b8bfa204f5c6')
      }
      steps {
        sh """
        cat /etc/os-release
        docker version
        docker login -u=$QUAY_USR -p=$QUAY_PSW quay.io
        bash -x ./scripts/build-image.sh
        """
      }
    }
  }
}