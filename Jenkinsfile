def build = currentBuild.previousBuild
if (build == null) {
    dockertag_id = 1
} else {
    while (build != null) {
        if (build.result == "SUCCESS")
        {
            lastSuccessfulBuildID = build.id as Integer
            def actions = lastSuccessful.getActions(hudson.model.ParametersAction)
            dockertag_id = actions.find { it.getParameterName() == 'DOCKERTAG_ID' }?.getResolvedValue()?.toInteger() ?: 1
            break 
            //lastSuccessfulBuildID = build.id as Integer
            //def lastSuccessful = Jenkins.instance.getItemByFullName(JOB_NAME).getBuildByNumber(lastSuccessfulBuildID)
            //def actions = lastSuccessful.getActions(hudson.model.ParametersAction)
            //dockertag_id = actions.find { it.getParameterName() == 'DOCKERTAG_ID' }?.getResolvedValue()?.toInteger() ?: 1
            //dockertag_id = lastSuccessfulBuildID.getEnvVars("DOCKERTAG_ID").toInteger()
            //break
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
