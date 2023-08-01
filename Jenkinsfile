def lastSuccessfulBuild = currentBuild.getPreviousBuildForStatus(hudson.model.Result.SUCCESS)
dockertag_id = 0
if (lastSuccessfulBuild) {
    dockertag_id = lastSuccessfulBuild.getEnvVars()["DOCKERTAG_ID"]
}
pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        DOCKERTAG_ID = "${dockertag_id}"
    }
    stages {
        stage("Clean-up") {
            steps {
                deleteDir()
            }
        }
        stage("Clone repo") {
            steps {
                sh "git clone https://github.com/JanhviMaddeshiya/notejam-kube/"
            }
        }
        stage("Log-in") {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        stage("Get last successful build's DOCKERTAG_ID") {
            steps {
                script {
                    def lastSuccessfulBuild = currentBuild.getPreviousBuildForStatus(hudson.model.Result.SUCCESS)
                    if (lastSuccessfulBuild) {
                        DOCKERTAG_ID = lastSuccessfulBuild.getEnvVars()["DOCKERTAG_ID"]
                    }
                }
            }
        }
        stage("Build") {
            steps {
                sh "docker build -t janhvimaddeshiya/notejam-tag:${DOCKERTAG_ID} notejam-kube/"
            }
        }
        stage("Push-repo") {
            steps {
                sh 'docker push janhvimaddeshiya/notejam-tag:${DOCKERTAG_ID}'
            }
        }
    }
}
