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
      * ```
        kubectl create secret generic db-user-pass \
        --from-literal=username=devuser \
        --from-literal=password='S!B\*d$zDsb='
        ```
    * check secret
      * ```kubectl get secret db-user-pass -o jsonpath='{.data}'```
    * encode secretbox
      * ```kubectl delete secret <secret name>```

## how to use
  * There are three main ways for a Pod to use a Secret:
