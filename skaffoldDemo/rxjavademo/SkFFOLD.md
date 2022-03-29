## #博客大赛# minimal CI/CD 工具 skaffold
&nbsp;
* 阅读时长：30min
*  <font color="yellow" size="5">**背景**</font>
<br /> &nbsp;&nbsp;&nbsp;&nbsp; 项目上使用了很多的ops工具，但是每一个ops的工具又只使用了一部分的功能。其中Jenkins用来构建我们的pipeline主体框架，打包镜像是采用的**skaffold**中**jib**模式，镜像的推送采用的是jenkinsX，部署又是使用的**helm+argocd**。工具太多，看得人天花乱醉的。让人觉得这个项目很高大上哈哈哈。然后我们不想让这个项目在我们看起来很高大上，所以我们准备一个一个的把这些ops工具来变low（熟悉）。在这篇文章中，我会给大家讲讲如何使用<font color="blue" size="5">skaffold</font>， 因为skaffold的作用远不止只有打包镜像。除了项目中用到的这一个功能，skaffold还能当做一个小型的pipeline。囊括了镜像构建，测试以及部署。

* <font color="Green" size="5">**Skaffold是什么?**</font>
    Skaffold是一个可以让kubernetes本地应用程序的持续开发更容易的命令行工具，换句话来说Skaffold能够用很便捷的方式在本地k8s集群中很快部署的一类工具。
      * 利用dockerfile，jib（Maven&Gradle）等工具打包镜像以及推送镜像
      * 与kubectl或者helm chart集成，在本地k8s集群中部署docker镜像
      * 利用container-structure-test或者test command测试镜像或者代码 
      * 热更新服务
      * 端口暴露
    * Skaffold的主要workflow包括代码变动的检查，代码镜像的构建，镜像的测试，镜像的推送以及镜像的部署。是一个可以实现一个最小单元的minimal pipeline，如摘自官网的【图一】所示。
    * Skaffold是一个基于**golang**开发的**cobra.Command** library的CLI应用工具。使用brew install skaffold安装好之后，skaffold的可执行文件被移动到了系统的 **/usr/local/bin**目录下。
    ![【图一】](https://user-images.githubusercontent.com/6279298/160609255-b9b1fe0c-853e-467e-9c17-acd31743e29f.png)
<p style="text-align:center" > 【图一】 </p>

* <font color="pink" size="5">**怎么用？**</font>
    </br> &nbsp;&nbsp;&nbsp;&nbsp;上面说了这么多的skaffold的介绍，那么这个工具具体怎么用？本文将以**java webflux application**来作为我们的demo。
    * Prerequisite
        * 统一用<font color="rgb(249,208,148)" size="10">Homebrew</font>的工具
            * Java 1.8 ```brew install java```
            * Maven ```brew install maven```
            * Skaffold ```brew install skaffold```
            * Minikube ```brew install minikube```
            * Docker ```brew install docker```
        * kubectl
            * ```curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.7.0/bin/darwin/amd64/kubectl```
            * ```chmod +x ./kubectl```
            * ```sudo mv ./kubectl /usr/local/bin/kubectl```
        * Jib (在pom文件中插入一个plugin section)
    * workflow
        * Skaffold初始化
            * 在当前项目的目录下执行<font style="font-family:courier;" size="4">***Skaffold init***</font>，skaffold会根据项目构建工具来进行打包。因为在pom文件中指定了jib打包，如【图二】所示。当skaffold检测到项目中使用的jib 插件打包项目镜像时，将会出现如【图三】所示的提示。 
            ![【图二】](https://user-images.githubusercontent.com/6279298/160611958-6d8a5056-5cea-4f8b-91a7-735b2f103068.png)
            <p style="text-align:center" > 【图二】 </p>

            ![【图三】](https://user-images.githubusercontent.com/6279298/160623736-9666d566-ddc0-49f1-8c39-5c9f8b4c6905.png)
            <p style="text-align:center" > 【图三】 </p>
            
            * Tips：    
                * 如果使用skaffold的init命令来初始化manifest，默认会初始化使用kubectl的方式来部署镜像。所以会出现如【图四】所示的错误。处理方式很简单，在当前目录下添加上k8s manifest（最简单就是一个pods.yaml文件，如果需要配置更多，加上对应的deployment，

                * 如果对于k8s manifest没有什么特殊的要求（只需要让当前项目能够在本地的k8s cluster中run起来）
                    * 生成k8s manifest  
                    ```
                    kubectl create deployment my-app --image=my-image --dry-run -o yaml > deployment.yaml
                    ```   
                    * 在run skaffold init生成对应的skaffold
                    service）即可。

        ![【图四】](https://user-images.githubusercontent.com/6279298/160624657-094f90bd-6179-455a-948f-77dac043a3ce.png)
            <p style="text-align:center" > 【图四】 </p>
        
        * 构建镜像
            * 运行命令<font style="font-family:courier;" size="4">***skaffold build***</font>
            * skaffold提供给了多种打包方式，包括Dockerfile，jib maven&gradle，buildpacks，Bazel，Ko，custom script。
            * 当前demo中使用了jib maven的方式打包，只需要在skaffold中指定build的方式如下所示的配置：

            ```yaml
            build:
                artifacts:
                - image: skaffold-webflux-example
                    jib:
                    args:
                    - -Psync
                    sync: 
                        auto: true
                local: {}
            ```
            * 在运行<font style="font-family:courier;" size="4">***docker images***</font>查看镜像是否，打包成功，如【图五】所示：

            ![【图五】](https://user-images.githubusercontent.com/6279298/160626812-97cc9ac5-3200-46d9-9268-797b578a3944.png)
            <p style="text-align:center" > 【图五】 </p>                  

        * 测试镜像
            * 当镜像构建成功之后，运行<font style="font-family:courier;" size="4">***skaffold test –images skaffold-webflux-example***</font>测试镜像是否打包成功，以及使用shell脚本运行unit test或者其他测试内容。
            * 测试的种类
                * structureTests（镜像的结构测试，如command测试，fileExist测试，fileContent测试）
                * Custom （指定测试脚本）

        * 部署镜像
            * 部署方式的支持
                * Kubectl <font color="yellow">*</font> （在demo中采用kubectl apply的方式来部署镜像）
                    * 运行命令<font style="font-family:courier;" size="4">***Skaffold deploy***</font>，并在skaffold.yaml中加入如下的配置：
                    ```yaml
                    deploy:
                        kubectl:
                            manifests:
                            - k8s-web.yaml
                    ```
                    * 使用***kubectl get pods***，查看节点是否部署成功，如【图六】所示：
                    ![【图六】](https://user-images.githubusercontent.com/6279298/160628288-7d5d16a0-77e0-47c9-993c-32fa2823fce1.png)

                    * 使用***kubectl port-forward 【pods name】 8080:8080***, 运行```curl --get http://localhost:8080/hello```，查看服务是否能够成功被访问。（部署之后，k8s中的服务的端口并没有被暴露，所以需要操作一下端口映射）。
                * Helm
                * Kustomize
                * Docker

        
        * 其他功能
            * <font style="font-family:courier;" size="4">***Clean up***</font>（清除部署）
                * ctrl+C
                * Skaffold delete
            * <font style="font-family:courier;" size="4">***Tagpolicy***</font>（镜像版本号）
                * Git commit的索引号
                * Sha256编码
                * 环境变量
                * 时间戳
            * <font style="font-family:courier;" size="4">***Port forward***</font> （端口映射)
            ```yaml
                portForward:
                - resourceType: deployment
                resourceName: skaffold-webflux-example-web
                namespace: default
                port: 8080
                localPort: 8080    
            ```
            * <font style="font-family:courier;" size="4">***File sync***</font>（热部署）
                * auto，仅适用于jib，bulidpack的打包模式，加入一下配置
                ```yaml
                jib:
                    args:
                    - -Psync
                ```
                * infer
                * manual

        * 完整skaffold yaml manifest
        ```yaml
            apiVersion: skaffold/v2beta26
            kind: Config
            metadata:
            name: rxjavademo
            build:
            tagPolicy:
                envTemplate:
                template: "{{.FOO}}"
            artifacts:
            - image: skaffold-webflux-example
                jib:
                args:
                - -Psync
                sync: 
                auto: true
            local: {}
                
            deploy:
            kubectl:
                manifests:
                - k8s-web.yaml

            test:
            - image: skaffold-webflux-example
                structureTests:
                - './structure-test/*'
                custom:
                - command: ./scripts/test.sh
                    timeoutSeconds: 60

            portForward:
            - resourceType: deployment
            resourceName: skaffold-webflux-example-web
            namespace: default
            port: 8080
            localPort: 8080    
        ```

* <font color="orange" size="5">**坑！！！**</font>
    * <font color="" size="4">**这个是做这个分享中最坑的一个部分！！!**</font>根据文档中的介绍，如果是使用jib模式的话，可以采用```auto aync```的方式。设置之后，并不生效，反而会报错， ```WARN[0044] Skipping deploy due to sync error: copying files: didn't sync any files```
    * 在git上遇见相同的问题
        [Skipping deploy due to sync error: copying files: didn't sync any files #4246
        ](https://github.com/GoogleContainerTools/skaffold/issues/4246)
    
    * 当时我使用的版本是**1.35.0**，然后我升级到了最新的版本```brew ungrade skaffold```，然后deploy镜像，满心欢喜的想着，改变代码，能够热部署。文件确实被显示生效了，但是，application的内容并没有更新。如下所示：
        ![not work](https://user-images.githubusercontent.com/6279298/160637419-babb88a1-7190-4076-83fa-6e7b36d2f356.gif)
    * 没生效之前采用的部署模式是**skaffold+helm**的模式（为啥没有生效得继续读读源码了23333），我换了一种模式，采用了**skaffold+kubectl**的部署模式。首先在项目的pom文件中添加一个id为sync的Profiles，该依赖的作用是，只要类路径上的文件发生变化，使用**spring-boot-devtools**的应用程序就会[自动重启](https://docs.spring.io/spring-boot/docs/current/reference/html/using.html#using.devtools.restart)，如下所示：
        ```xml
            <profiles>
                <profile>
                    <id>sync</id>
                    <dependencies>
                        <dependency>
                            <groupId>org.springframework.boot</groupId>
                            <artifactId>spring-boot-devtools</artifactId>
                            <optional>true</optional>
                        </dependency>
                    </dependencies>
                </profile>
            </profiles>
        ```
    * 然后在skaffold.yaml的**build**的section中加了以下的内容，这样可以为maven传递参数，从而激活profile，让application重新启动
        ```yaml
        jib:
            args:
            - -Psync
        ```
    * 终于成功了！！！！
    ![ok](https://user-images.githubusercontent.com/6279298/160638449-ee65fd8b-d833-42b3-a5f6-0ebc0b67e8ae.gif)

* <font color="RED" size="5">**应用场景**</font>
    * 作为pipeline中的镜像打包和上传工具
    * 本地镜像构建工具
    * Minimal pipeline
    * Demo showcase
* <font color="BROWN" size="5">**总结**</font>
    * Pros
        * Skaffold可以让本地的k8s部署变得更简单，只需要配置好对应的manifest
        * 功能可以拆分使用，比较灵活
        * Skaffold配置内容比较简单
        * Open-source 工具，有社区力量支持
    * Cons
        * 如果要了解更多的内容可能需要一定的学习成本，包括golang的基础，k8s的部署基础。

</br>

* <font style="font-family:courier;" size="5" color="yellow">感谢大家看到最后，如果不正确的地方，不吝赐教</font> 
