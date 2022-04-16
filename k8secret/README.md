# how to use secret in k8s

* encryption method

| name | Description | Strength | Key Length |
| :--- |    :----:   |     ---: |       ---: |
|identity default| None | test | test |
|secretbox| XSalsa20 and Poly1305| Strong | 32 byte
|aesgcm| AES-GCM with </br> random nonce | Must be rotated </br> every 200k writes| 16, 24, </br> 32-byte |  
|aescbc| AES-CBC with </br> PKCS#7 padding | Weak | 32-byte	
|kms | very complex | Strongest | 32 byte |

* define access resource
  * PodSecurityPolicy
  * RBAC
  * Authentication

## how to create secret resource

* create secret from kubectl command
  * from file
    * cmds  
    ```
    kubectl create secret generic db-user-pass \
      --from-file=./username.txt \
      --from-file=./password.txt
    ```
  * from command line
    *```
      kubectl create secret generic db-user-pass \
      --from-literal=username=devuser \
      --from-literal=password='S!B\*d$zDsb='
      ```
  * check secret
    * ```kubectl get secret db-user-pass -o jsonpath='{.data}'```
  * encode secretbox
    * ```kubectl delete secret <secret name>```
* create secret from configuration
  * create secret yaml file
  * run ```kubectl apply -f <your secert yaml>```

## how to use

* There are three main ways for a Pod to use a Secret:
  * As files in a volume mounted on one or more of its containers.
    * add a pod yaml to access to secret
    * tips:
      * add spec.volumeMount section to save the secrect
      * add spec.volume to mount secret from pod and the should be **same** as the secretName
      * use cmd ```kubectl exec <pod name> -it bash```, get into the pods and cd to **/etc/podsecret**
      ![mounted secret](https://user-images.githubusercontent.com/6279298/163657055-a34866d1-dcbf-4906-9e1a-0475821185d0.png)
  * As container environment variable.
    * add env section
    ![get env](https://user-images.githubusercontent.com/6279298/163657778-d357e775-7bfc-4c12-a9f2-8f5e7d7d5b28.png)
  * By the kubelet when pulling images for the Pod.
