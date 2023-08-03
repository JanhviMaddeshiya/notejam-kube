def counter = 0
def data = "V" + counter
writeFile(file: 'version.txt', text: counter.toString())
 if (fileExists()) {
     def build = currentBuild.previousBuild
     while (build != null) {
        if (build.result == "SUCCESS")
            {
               def DOCKERTAG_ID = data
            }
     }
}
def readcounter = readFile(file: 'version.txt')
readcounter=readcounter.toInteger() +1
def DOCKERTAG_ID = readcounter
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
        stage('read') {
            steps {
                stage {
                    def readcounter = readFile(file: 'version.txt')
                    readcounter=readcounter.toInteger() +1
                    def DOCKERTAG_ID = readcounter
                }
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
                sh "docker push janhvimaddeshiya/notejam-tag:${DOCKERTAG_ID}"
            }
        }
    }
}

