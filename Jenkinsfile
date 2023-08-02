pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        DOCKERTAG_ID = 1
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
        stage("search") {
            steps {
                script {
                    def build = currentBuild.previousBuild
                    if (build == null) {
                        env.DOCKERTAG_ID = 1
                    } else {
                        while (build != null) {
                            if (build.result == "SUCCESS")
                            {
                                //def VAL1 = jenkins.model.Jenkins.instance.getItem('JOBNAME').lastBuild.getBuildVariables().get("DOCKERTAG_ID")
                                //lastSuccessfulBuildID = build.id as Integer
                                lastSuccessfulBuildID = build.getBuildVariables().get("DOCKERTAG_ID") 
                                // dockertag_id = lastSuccessfulBuildID.description
                                //DOCKERTAG_ID = previousBuild.description
                                env.DOCKERTAG_ID = "${lastSuccessfulBuildID + 1}" 
                                break
                            }
                            build = build.previousBuild
                        }
                    }
                    echo "docker" 
                    echo DOCKERTAG_ID as String
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
                sh "docker push janhvimaddeshiya/notejam-tag:${DOCKERTAG_ID}"
            }
        }
    }
}

