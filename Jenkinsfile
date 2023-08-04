def lastSuccessfulBuildID = 0
def version = 0
def buildNumber = currentBuild.number
def build = currentBuild.previousBuild
if (build == null) {
    version = 1
}
while (build != null) {
    if (build.result == "SUCCESS") {
        lastSuccessfulBuildID = build.id as Integer
        version = lastSuccessfulBuildID + 1
        break
    } else if(build.result == "FAILURE") {
        lastSuccessfulBuildID = build.id as Integer
        version = buildNumber - lastSuccessfulBuildID
    }
    build = build.previousBuild
}
pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
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
                sh "docker build -t janhvimaddeshiya/notejam-tag:${version} notejam-kube/"
            }
        }
        stage("Push-repo") {
            steps {
                sh "docker push janhvimaddeshiya/notejam-tag:${version}"
            }
        }
    }
}

