# How to collect, manage and visualize our log data?

***author: zengqiang fang***

## Backgroud

## Logs management frameworks

### ELK elasticsearch logstash kibana

&nbsp;&nbsp;&nbsp;&nbsp;**ELK** is a framework which is provided by elastic search orgnaization. This framework can be divided into three part. The heart, **elasticsearch** collects data and is a data searching engine, which can provide and save data. It can be deployed onto k8s cluster and excute scalation automatically. Then **logstash** is used to format log and send collecting data to elasticsearch, like a **pipeline**. In the end, **kibana** is used to visulize the data in elastice search. What's more, a log collecting tool, **beat (Filebeat)** also need to set up for collection application log and send the log to logstash. And the whole flow is can be presented as the Pic1.

![Pic1](https://user-images.githubusercontent.com/6279298/167979333-e95a53ab-c13e-4ceb-bca2-21196a57d3dc.png)

### EFK elasticsearch fleuntd kibana

## How to use

### ELK

#### Deploy elasticsearch engine in k8s

* add [es-manual.yaml file](https://github.com/Fdslk/ops/blob/main/ELK/es-manual.yaml) which includes k8s deployment configuration and service configuration. Service file is used to expose es-manual pod. Then other services can access to elasticsearch service freely. If you want to run es deployment in your local machine, you might specify the **"discovery.type"** is equal to **"single-node"**. Otherwise, you will get the following errors.

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

#### Deploy kibana in k8s

* add a [kibana deployment manifest](https://github.com/Fdslk/ops/blob/main/ELK/kibana-elk.yaml) include deployment image and service information. Meanwhile, the elasticsearch expose url should be added into k8s container as environment variable. Like, **ELASTICSEARCH_HOSTS**.

#### Deploy logstash in k8s

#### Deploy Filebeat and Log generating application

## How difference between them

## Conclusions
