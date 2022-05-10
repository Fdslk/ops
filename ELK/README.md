# How to collect, manage and visualize our log data?

***author: zengqiang fang***

## Backgroud

## Logs management frameworks

### ELK elasticsearch logstash kibana

&nbsp;&nbsp;&nbsp;&nbsp;**ELK** is a framework which is provided by elastic search orgnaization. This framework can be divided into three part. The heart, **elasticsearch** collects data and is a data searching engine, which can provide and save data. It can be deployed onto k8s cluster and excute scalation automatically. Then **logstash** is used to format log and send collecting data to elasticsearch, like a **pipeline**. In the end, **kibana** is used to visulize the data in elastice search.

### EFK elasticsearch fleuntd kibana

## How to use

### ELK

#### Deploy elasticsearch engine in k8s

* add es-manual.yaml file which includes k8s deployment configuration and service configuration. Service file is used to expose es-manual pod. Then other services can access to elasticsearch service freely.

#### Deploy kibana in k8s

#### Deploy logstash in k8s

## How difference between them

## Conclusions
