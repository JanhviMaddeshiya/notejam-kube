pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    }
    stages {
        stage("Read Version Number") {
            steps {
                script {
                    def buildNumber = env.BUILD_NUMBER.toInteger()

                    def lastSuccessfulBuildTag = ""
                    def previousBuild = currentBuild.previousBuild
                    while (previousBuild != null) {
                        if (previousBuild.result == "SUCCESS") {
                            lastSuccessfulBuildTag = previousBuild.env.DOCKERTAG_ID
                            break
                        }
                        previousBuild = previousBuild.previousBuild
                    }

                    def majorVersion = 1
                    def minorVersion = buildNumber
                    if (lastSuccessfulBuildTag != "") {
                        // If a successful build exists, use its minor version.
                        minorVersion = lastSuccessfulBuildTag.split("\\.")[1].toInteger()
                    }

                    def version = "${majorVersion}.${minorVersion}"

                    // Set the DOCKERTAG_ID with the version.
                    DOCKERTAG_ID = version
                }
            }
        }
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
