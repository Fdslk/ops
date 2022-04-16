# sealed secret

![workflow of sealed secret](https://user-images.githubusercontent.com/6279298/163666361-138ec9a9-1dda-4536-b77f-43a97a57e97d.png)

## what is the sealed secret

* secret should not be push to github with simple encryption.
* the certification only can be fetch from the secret-service-controller during the runtime. 

## why we use sealed secret

* to make our credential data more secure

## how to use sealed secret

* pre-requirement
  * use helm to install secret-service-controller
  * use the following cmd to install secret service

    ```
        helm install sealed-secrets-controller sealed-secrets/sealed-secrets -n kube-system
    ```
  * brew insatll kebuseal
    * it can be used to seal the secret which can be commited to remote repo
  * use the following cmd to encrypt the secret  
    ``` 
    kubeseal --cert http://localhost:8080/v1/cert.pem <../secret.yaml> ./database-encrptyed-secret.yaml -o yaml
    ```
  * use ```kubectl apply -f database-encrptyed-secret.yaml``` to deploy secret resource
  * use the following cmd to decode secret
  ```
     echo $(kubectl get secret databasesecret -o jsonpath={.data.username})|base64 -D
  ```

    * tips:
        if the following **error** happens to you, you can use kubectl port-forward to expose secret-service-controller.
        ```
        (tty detected: expecting json/yaml k8s resource in stdin)
        error: cannot fetch certificate: no endpoints available for service "sealed-secrets-controller"
        ```

    ![decode secret](https://user-images.githubusercontent.com/6279298/163665560-022bcb12-bf54-4177-8f3d-74faf14ee41a.png)
