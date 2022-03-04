# helm一种CI/CD工具

* definition: helm可以被当做是k8s的包管理工具，利用helm可以部署自己的应用程序以及其他依赖服务应用，如redis，mysql等等。

* 如何在本地的k8s集群中使用helm部署服务

  * preparation

    * docker-desktop or minikube

    * brew install helm

    * using helm version to check it works

  * helm create ```<your chart name>```

  * create a folder name webdemo

    * folder structure

      * template/ 存储一些基本的k8s部署文件

      * Chart chart包的基本信息

      * values.yaml 模板信息中的替换信息

  * helm packge ```<you are chart>``` 创建部署tgz包

  * helm install ```<your server name>``` ```<your chart tgz package name>```

  * helm list 列出部署成功服务

  ![成功截图](https://user-images.githubusercontent.com/6279298/156680275-7d2c8297-a7bc-4b3c-8b46-591bb20cac90.png)

  * helm delete 删除部署以及k8s中的部署

  * helm get manifest 列出部署chart的k8s manifest文件

   ![成功截图](https://user-images.githubusercontent.com/6279298/156680958-0fa1870a-21fe-4c75-9741-fd00e12c0082.png)

* 如何添加自己的application

* 如何将helm添加到Jenkins
