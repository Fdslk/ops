# Varnish using for new fresh

* **What** is varnish
  * Varnish is a http  cache tool for accelerating http request response.
  * The configuration language of varnish is named as **VCL**, which can handle the incoming requests
    * decide what content you want to server
    * from where you want to get the content
    * how the request or response should be altered
    * beef-sandwich
    ![varnish in network](https://user-images.githubusercontent.com/6279298/165006846-8501c3a2-e6ea-43c6-81c1-88416128468c.png)
    * How does it work
      * based on VCL program, it can 'Which backend has this content, how long time can we cache it, is it accessible for this request, should it be redirected elsewhere and so on'.
      * **VCL** can be compiled into C-program which is complied into a shared lib. **This will happen to varnish loads VCL program.**
  * core features
    * caching, using Cache-Control HTTP header
    * Content Composition
    * support many different OS platforms
    * full control of every request

* **How** to install varnish
  * ```brew install varnish```
  * ```sudo mv  /usr/local/opt/varnish/sbin/varnishd /usr/local/bin/```
  * then varnishd can be executed directly

* **How** to use varnish
  * in local
    * add default.vcl file
    * run the following cmd ```varnishd -a :6081,HTTP -f default.vcl -F```
      * -a listening port
      * -f configuration file location
      * -F run varnish in the front
    * call the ```127.0.0.1/api/public``` for testing
  * by docker
    * use docker cmd directly
      ```
      docker run --rm -v $(PWD)/default-docker.vcl:/etc/varnish/default.vcl:ro \  
          --tmpfs /var/lib/varnish/varnishd:exec \
          --name my-varnish-container \
          -p 8081:80 \
          -e VARNISH_SIZE=2G \
          varnish
      ```
      * varnish proxy the local machine service, the host of vcl should be set as **"docker.mac.for.localhost"**.
      * tips:
        * varnish port in docker is **80**
    * use docker file
      * create a docker file
      * mount the vcl file into your custom image
      * run your custom image
        ```
        docker run -it --tmpfs /var/lib/varnish/varnishd:exec -p 8081:80 local-varnish
        ```
    * docker-compose
  * in local k8s
    * create k8s configMap for mounting default.vcl
    ```kubectl create configmap varnish-vcl --from-file=default.vcl```
    * deploy 
