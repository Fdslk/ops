# skaffold for CI/CD

## pre-requirement

* docker file
* application
* k8s yaml
* how to run
  * skaffold init
  * skaffold build
  * skaffold dev/debug
* issues:
  * ./mvnw cannot execute
  ```run chmod +x ./mvnw```
  * ```derr: "/Users/zengqiangfang/Documents/code/ops/skaffoldDemo/javaApplication/mvnw: line 257: /Users/zengqiangfang/Documents/code/ops/skaffoldDemo/javaApplication/.mvn/wrapper/maven-wrapper.properties: No such file or directory\n/Users/zengqiangfang/Documents/code/ops/skaffoldDemo/javaApplication/.mvn/wrapper/maven-wrapper.jar: No such file or directory\nError: Could not find or load main class org.apache.maven.wrapper.MavenWrapperMain\nCaused by: java.lang.ClassNotFoundException: org.apache.maven.wrapper.MavenWrapperMain\n"```

  ```run mvn -N io.takari:maven:wrapper```
  * Failed to execute goal com.google.cloud.tools:jib-maven-plugin:3.1.4:dockerBuild (default-cli) on project skaffold-spring-boot-example: Main class was not found, perhaps you should add a `mainClass` configuration to jib-maven-plugin
  
  ``` 
  add this tag in the <container>
  <mainClass>main.hello.Application</mainClass>
```

  * ```[web-56f866ff75-6p7qw web] Error: Could not find or load main class main.hello.Application```
