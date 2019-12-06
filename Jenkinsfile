pipeline {

    agent {
        //设置运行的节点
        label 'master'
    }
    
    triggers {
        GenericTrigger(
            genericVariables: [
                [key: 'ref', value: '$.ref', expressionType: 'JSONPath'],
                [key: 'payload', value: '$', expressionType: 'JSONPath'],
            ],
            causeString: 'Triggered on $ref',
            token: 'demo1',
            regexpFilterExpression: 'refs/heads/' + BRANCH_NAME,
            regexpFilterText: '$ref',
            printContributedVariables: true,
            printPostContent: true
        )
    }

    tools {
            //maven工具
            maven 'maven3.3.9'
        }

    stages {
        //获取代码
        stage('SCM') { 
            steps {
                git branch: "${env.BRANCH_NAME}", credentialsId: 'github', url: 'git@github.com:mapsic/demo1.git'
                }                     
       }    

       //使用maven打包
        stage('Build') {
            steps {       
                sh "mvn clean install  -DskipTests"
                sh "cp -rf target/demo1.jar src/main/docker/demo1.jar"
                }     
            }        

        stage('Image') {

            steps {

                script {

                    dir ('src/main/docker') {

                    /* 构建镜像 */
                    def customImage = docker.build("bitsoda2019/demo1:${env.BRANCH_NAME}-${BUILD_NUMBER}")

                    /* hub.xxxx.cn是你的Docker Registry */
                    docker.withRegistry('https://registry.cn-hongkong.aliyuncs.com', 'my-docker-registry') {
                        /* Push the container to the custom Registry */
                        customImage.push()
                    }
                  }     
                }   
            }
        }

        //部署到test环境                 
        stage('Deploy to Test') {

            when {
                ${env.BRANCHE_NAME} 'develop'
            }

            steps {
                echo 'Deploy to Test'
                
                
            }
        }

        //部署到prod环境
        stage('Deploy to Prod') {

            when {
                ${env.BRANCH_NAME} 'master'
            }

            steps {
               sh "kubectl set image deploy demo1 demo1=registry-vpc.cn-hongkong.aliyuncs.com/bitsoda2019/demo1:${env.BRANCH_NAME}-${BUILD_NUMBER} -n ops"
            }
        }
    }
}
