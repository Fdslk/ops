# **How to collect, manage and visualize our log data?**

***author: zengqiang fang***

***words: 1208***
## **Backgroud**
&nbsp;&nbsp;&nbsp;&nbsp; During our daily working, application status, the content of http request and response, exception message, etc, which are very useful to us for debugging online issues and monitering applications. Therefore, it is necessary to collect log data and visualize log records picture. In the past, we recorded log information into log file. Then, we logined to server to check log information or downloaded log file. According to this way, it is not only very hard to analyze log in real time, but also it is too diffcult to search or filter log by key words. Nowadays, more and more services and systems are deploy in k8s clusters. Therefore, it's no hesitation to find a new way to collect and visualize data. In the article, we will introduction two k8s suppported log framework, which are **ELK** and **EFK**. **E** has the same meaning for these two frameworks, ElasticSearch engine. **L** means the **logstash**, log agent. **F** is **fluentd**, k8s pods level log collecting application. And **K** also are point to a same application, Kibana. It is used to visualized log. During the rest of this article, we will have detailed description about what are they and how to use them.

## **Logs management frameworks**

### **ELK elasticsearch logstash kibana**

&nbsp;&nbsp;&nbsp;&nbsp;**ELK** is a framework which is provided by elastic search orgnaization. This framework can be divided into three part. The heart, **elasticsearch** collects data and is a data searching engine, which can provide and save data. It can be deployed onto k8s cluster and excute scalation automatically. Then **logstash** is used to format log and send collecting data to elasticsearch, like a **pipeline**. In the end, **kibana** is used to visulize the data in elastice search. What's more, a log collecting tool, **beat (Filebeat)** also need to set up for collection application log and send the log to logstash. And the whole flow is can be presented as the Pic1.

![Pic1](https://user-images.githubusercontent.com/6279298/167979333-e95a53ab-c13e-4ceb-bca2-21196a57d3dc.png)

### **EFK elasticsearch fluentd kibana**

&nbsp;&nbsp;&nbsp;&nbsp;**EFK** is a log framewrok and similar to **ELK** log framework. EFK is log agent to collect log data and sends log data to elasticsearch. EFK is supported two endpoints which are **Stackdriver Logging** and **ElasticSearch**. Fluentd is a DeamonSet k8s resource which can be deployed into k8s Nodes as a Deamon Pod. This special pods will manage the pods in the same Nodes. Therefore, **EFK** just needs to deploy elasticsearch Pods, kibana interface Pods, fleuntd DeamonSet.

## **How to use**

### **ELK**

#### **Deploy elasticsearch engine in k8s**

* add [es-manual.yaml file](https://github.com/Fdslk/ops/blob/main/ELK/es-manual.yaml) which includes k8s deployment configuration and service configuration. Service file is used to expose es-manual pod. Then other services can access to elasticsearch service freely. If you want to run es deployment in your local machine, you might specify the **"discovery.type"** is equal to **"single-node"**. The default discovery.type for elasticsearch is **multi-node**. If es was set as a multi-node cluster, it would to discovery other nodes. Therefore, some discovery configurations need to be set up. Otherwise, you will get the following errors. 

```
ERROR: [1] bootstrap checks failed
[1]: the default discovery settings are unsuitable for production use; at least one of [discovery.seed_hosts, discovery.seed_providers, cluster.initial_master_nodes] must be configured
ERROR: Elasticsearch did not exit normally - check the logs at /usr/share/elasticsearch/logs/docker-cluster.log
```

* When everything of es is set up correctly, you can input ```curl http://localhost:<expose port>``` in your iterms, the following result you will receive:

    ```json
    {
        "name" : "es-manual-ccd547885-4czd4",
        "cluster_name" : "docker-cluster",
        "cluster_uuid" : "WbVh_VIjS42ppWYuGwovog",
        "version" : {
            "number" : "7.8.0",
            "build_flavor" : "default",
            "build_type" : "docker",
            "build_hash" : "757314695644ea9a1dc2fecd26d1a43856725e65",
            "build_date" : "2020-06-14T19:35:50.234439Z",
            "build_snapshot" : false,
            "lucene_version" : "8.5.1",
            "minimum_wire_compatibility_version" : "6.8.0",
            "minimum_index_compatibility_version" : "6.0.0-beta1"
        },
        "tagline" : "You Know, for Search"
    }
    ```

#### **Deploy kibana in k8s**

* add a [kibana deployment manifest](https://github.com/Fdslk/ops/blob/main/ELK/kibana-elk.yaml) include deployment image and service information. Meanwhile, the elasticsearch expose url should be added into k8s container as environment variable. Like, **ELASTICSEARCH_HOSTS**. After successfully deploying, command ```curl http://localhost:32184/status``` can be used to check kibana is ready or not. For here, I have question. If I used exposed services ip:port, kibana cannot access to es pods. However, when I used the nodes cluster IP: ```192.168.65.4:<external exposed port>```. What's more, you also can utilize k8s service name as hostname with target port to communicate with es pods. When kibana runs up, the following pic can be shown after you access to ```http://localhost:32184``` on your browse:
![pic2](https://user-images.githubusercontent.com/6279298/168193484-750f822b-fad8-491c-8d64-3125c5190e2c.png)

#### **Deploy logstash in k8s**

* add [logstash k8s manifest file](https://github.com/Fdslk/ops/blob/main/ELK/logstash.yaml) and [configuration file](https://github.com/Fdslk/ops/blob/main/ELK/logstash.conf). Based on the first file, we can deploy logstash service in k8s cluster. In the second file, we will define the input and output of the data. logstash.config will be defined as a k8s configMap resource. Then deployment will volume the configMap into k8s pod, which can be used by logstash service.
  * input the following command to create ConfigMap
        ```
        kubectl create configmap logstash-config --from-file ./logstash.conf
        ```
  * create deployment
  * after logstash starts up, we can input ```kubectl logs <pods name> -f``` for obtaining useful log data.
  
  ```
    [2022-05-13T08:18:20,309][INFO ][logstash.outputs.elasticsearch][main] Installing elasticsearch template to _template/logstash
    [2022-05-13T08:18:21,040][INFO ][logstash.inputs.beats    ][main] Beats inputs: Starting input listener {:address=>"0.0.0.0:5044"}
    [2022-05-13T08:18:21,057][INFO ][logstash.javapipeline    ][main] Pipeline started {"pipeline.id"=>"main"}
    [2022-05-13T08:18:21,150][INFO ][logstash.agent           ] Pipelines running {:count=>1, :running_pipelines=>[:main], :non_running_pipelines=>[]}
    [2022-05-13T08:18:21,194][INFO ][org.logstash.beats.Server][main][be216883a18a1108d5ceab3d012b51b20564d3e53d37fdaf62f0441690df42ff] Starting server on port: 5044
    [2022-05-13T08:18:21,439][INFO ][logstash.agent           ] Successfully started Logstash API endpoint {:port=>9600}
  ```

#### **Deploy Filebeat and Log generating application**

* In the end, we will deploy the log collector sidercar, Filebeat. It will collect log data from a sharing log file and send the data to the logstash. At first, we need to define [filebeat manifest](https://github.com/Fdslk/ops/blob/main/ELK/filebeat.yml), which will illustrate where does filebeat read log and where does the log write. You can input the command to create configMaps for filebeat configuration ```kubectl create configmap file-beat-config --from-file ./filebeat.yml```. Then this configuration will be volumed into pods. When you deploy the log generator application and filebeat application. Then logstash will receive log data from listening port. To check the log system works normally or not. You can open your browser and input ```http://localhost:32184/```, kibana GUI will represent to you as follows **pic3**. In order to see the log information, a **Index Pattern** needs to create at first.
  * how to create "Index Pattern"
    * open kibana dashboard
    * click stack management
    * click index pattern
    * create new index pattern like **filebeat***
![pic3](https://user-images.githubusercontent.com/6279298/168613317-c88bbf58-3af2-4706-8e12-383a321801a5.png)

* At here you have learned how to make a ELK log system on your application.

### **EFK**

#### **Deploy elasticsearch**

* The same as the former ElasticSearch deployment manifest
  
#### **Deploy kibana**

* The same as the former Kibana deployment manifest

#### **Deploy fluentd**

* At here, we will define a [DeamonSet manifest to deploy fluentd](https://github.com/Fdslk/ops/blob/main/ELK/fluentd-manual.yml) which deploy a Pods for collecting the Pods log and docker contanier log. If everything is set up correctly, you will see the following pic after input KQL ```kubernetes.namespace_name : "default"```.
  ![pic4](https://user-images.githubusercontent.com/6279298/169063264-d1088d57-00b4-4be7-b168-7597dcf4706c.png)

#### **Deploy business service application**

* In our daliy delievery, we always deploy our application in k8s. Take [log-application.yaml](https://github.com/Fdslk/ops/blob/main/ELK/fluentd-manual.yml) as an example, we use **slf4j.Logger** to print log on the application console. When a request hits the log-application, it will print its stdout on the console, which will be scaned by fluentd and it will send the log data to ElasticSearch. The following picture **pic5** will be represented.
  ![pic6](https://user-images.githubusercontent.com/6279298/169491169-7d6b4a79-9e18-4116-8be8-03ece9fe25a5.png)

## **How difference between them**

* **Components**
  * For this part, it is very obvious that **ELK** is componsed of ElasticSearch, Logstash, filebeats and Kibana. However, **EFK** just include ElasticSearch, fluentd and Kibana.
* **Mechanism**
  * In **ELK** framework, the core feature is the logstash. Logstash just likes a log transportion center which can re-process the format, filter and enrichment of logs. It's very memory-consuming. We can't deploy a logstash into a container with other logging application. Therefore, filebeat, lightweight log collector works as a log agent to send log to logstash.
  * In **EFK** framework, fluentd is the core feature. fluentd is deployed k8s cluster as a DeamonSet resource, which can collect the node metrics and log. And it doesn't need to another log transportion agents. Only if fluentd is set enought permission, the container and nodes log can be collected directly.
* **log agent performance**
  * logstash is written by JRuby and runs on JVM.
  * fluentd is written by CRuby, which consumes less memory than logstash.
* **Configuration**
  * logstash
    * You can add your own manifest to set up input and output rules, log format, etc.
  * fluentd
    * [fluentd UI browser](https://docs.fluentd.org/deployment/fluentd-ui) (Install, uninstall, and upgrade Fluentd plugins)
    * [Dockerfile](https://github.com/fluent/fluentd-kubernetes-daemonset/blob/master/docker-image/v1.14/debian-elasticsearch7/Dockerfile)
* **Usage scenarios**
  * For **ELK**, it needs more memory. Therefore, logstash might not suitable for the low-memory machine. On the other hand, **EFK** just consumes less memeory. In my opinion, EFK might have a wide range of application.
* More information
  * If you want to get more comparison information, you can take the following references a look.
  * [Difference Between Fluentd vs Logstash](https://www.educba.com/fluentd-vs-logstash/?source=leftnav)
  * [Kubernetes Logging: Comparing Fluentd vs. Logstash](https://platform9.com/blog/kubernetes-logging-comparing-fluentd-vs-logstash/)
  * [Fluentd vs. LogStash: A Feature Comparison](https://www.loomsystems.com/blog/single-post/2017/01/30/a-comparison-of-fluentd-vs-logstash-log-collector)

## **Conclusions**
* log-centralized
* real-time
* visualization
* open-reource and active communities for supporting unknow issues
* 
