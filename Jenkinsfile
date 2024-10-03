pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'roseaw/powercliimage'
        DOCKER_IMAGE_TAG = 'latest'
        VCENTER_CREDENTIALS_ID = 'taylorw8-vsphere'
    }

    stages {
        stage('Change RAM for VMs') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: env.VCENTER_CREDENTIALS_ID, usernameVariable: 'VCENTER_USER', passwordVariable: 'VCENTER_PASS')]) {
                        sh """
                        docker run --rm \
                            -e VCENTER_USER=\$VCENTER_USER \
                            -e VCENTER_PASS=\$VCENTER_PASS \
                            ${env.DOCKER_IMAGE_NAME}:${env.DOCKER_IMAGE_TAG} \
                            pwsh -File /usr/src/app/Change-RAM.ps1 -vCenterServer 'vcenter.regional.miamioh.edu' -vCenterUser \$VCENTER_USER -vCenterPass \$VCENTER_PASS
                        """
                    }
                }
            }
        }
        stage('Start VMs') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: env.VCENTER_CREDENTIALS_ID, usernameVariable: 'VCENTER_USER', passwordVariable: 'VCENTER_PASS')]) {
                        sh """
                        docker run --rm \
                            -e VCENTER_USER=\$VCENTER_USER \
                            -e VCENTER_PASS=\$VCENTER_PASS \
                            ${env.DOCKER_IMAGE_NAME}:${env.DOCKER_IMAGE_TAG} \
                            pwsh -File /usr/src/app/Start-VMs.ps1 -vCenterServer 'vcenter.regional.miamioh.edu' -vCenterUser \$VCENTER_USER -vCenterPass \$VCENTER_PASS
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            slackSend color: "good", message: "Build Completed Successfully: ${env.JOB_NAME} ${env.BUILD_NUMBER}"
        }
        unstable {
            slackSend color: "warning", message: "Build Unstable: ${env.JOB_NAME} ${env.BUILD_NUMBER}"
        }
        failure {
            slackSend color: "danger", message: "Build Failed: ${env.JOB_NAME} ${env.BUILD_NUMBER}"
        }
    }
}
