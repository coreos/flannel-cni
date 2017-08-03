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
        QUAY = credentials('quay-io_flannel-cni')
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