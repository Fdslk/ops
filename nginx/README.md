# 什么是Nginx

* Nginx是一个web服务器
* 监听http端口
* 静态或者动态的网站内容
* 反向代理
  * 负载均衡
  * 后端路由
    * eg：如果后端unhealthy的时候，可以做一些其他的事情，比如说使用其他的后端服务
  * 缓存（caching）
    * 减少和后端的一些的重复的调用
  * 网管API
    * 限制请求
    * 路由匹配 （根据API版本来路由匹配）

![nginx 架构图](https://user-images.githubusercontent.com/6279298/159614434-20698a4f-4a61-4c3d-9281-a0ea8c63e4aa.jpg)

* timeout in nginx
  * frontend timeouts (用户向nginx请求是发生的timeout)
    * client_header （读取用户https**请求头部**的timeout，默认60s）
    * client_body
    * send （默认60s，传输时间太长，导致超时，关闭链接）
    * keepalive （默认75s，不会让idle的链接一直空闲在那里，eg：如果一个链接太久不用了，就会被关闭）
    * lingering （用户可以发送请求，但是Nginx不会给回response，一直等待，网络超时，链接关闭）
    * resolver （DNS域名解析超时，默认30s
  * backend timeout
    * proxy_connect (NGINX和backend链接时，会有healthcheck，检查这个backend service是否正常工作，尽可能把这个设置的小，一般来说，**不要超过75s**)
    * proxy_send （定义为两次连续的写操作之间的时间，接下来的是content超过了设置的时间没有发送给backend，这样nginx到backend的链接就会超时，关闭）
      * 可以释放当前链接，以供其他的client建立链接
    * proxy_read （和写超时相反，nginx读后端返回数据时超时, 返回数据的时间太慢，proxy nginx将会关闭链接，有利于节约链接时长）
    * proxy_next_upstream （默认0s，一般设置在4-5s左右，不需要太长的时候去决定使用哪一个上游服务）
    * keepalive （减少空闲时间，如果太长时间没有数据的传输，关闭链接，一般设置为60s）
