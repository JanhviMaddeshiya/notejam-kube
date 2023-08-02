def dockertag_id
def build = currentBuild.previousBuild
if (build == null) {
    dockertag_id = 1
} else {
    while (build != null) {
        if (build.result == "SUCCESS")
        {
            def previousBuild = getPreviousBuild()
            if (previousBuild != null) {
                def lastSuccessfullBuild = build.getPreviousBuild()
                dockertag_id = lastSuccessfullBuild.${dockertag_id}
                break
            }
            break
        }
        build = build.previousBuild
    }
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
