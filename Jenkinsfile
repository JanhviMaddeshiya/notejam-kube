def DOCKERTAG_ID = 1
def build = currentBuild.previousBuild
while (build != null) {
    if (build.result == "SUCCESS")
        {
                                //def VAL1 = jenkins.model.Jenkins.instance.getItem('JOBNAME').lastBuild.getBuildVariables().get("DOCKERTAG_ID")
                                //lastSuccessfulBuildID = build.id as Integer
            lastSuccessfulBuildID = build.getBuildVariables().get("DOCKERTAG_ID") 
                                // dockertag_id = lastSuccessfulBuildID.description
                                //DOCKERTAG_ID = previousBuild.description
            DOCKERTAG_ID = "${lastSuccessfulBuildID + 1}" 
            echo DOCKERTAG_ID as String
            break
        }
        build = build.previousBuild
}
echo "docker" 
echo DOCKERTAG_ID as Stirng

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

