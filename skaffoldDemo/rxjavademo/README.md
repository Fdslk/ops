# rxjava skaffold demo

## test skaffold file sync section

* manual sync

* infer sync

* auto

  * jib

  * buildpack (default enable)

* issues: file sync print successfully, but the api is the original test

  * solution: after file sync, reload application add following configuration into pom:
  
  ```
  <profiles>
    <profile>
    <id>sync</id>
    <dependencies>
      <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-devtools</artifactId>
        <!-- <optional>true</optional> not required -->
      </dependency>
    </dependencies>
  </profile>

</profiles>

```

deploy:
    kubectl:
      manifests:
      - k8s-web.yaml
```
