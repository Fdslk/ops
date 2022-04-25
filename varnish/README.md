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

* **How** to use varnish
