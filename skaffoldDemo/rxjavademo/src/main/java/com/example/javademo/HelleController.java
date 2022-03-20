package com.example.javademo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class HelleController {
    @GetMapping("hello")
    public Mono<String> hello(){
        return Mono.just("hello mono sync test!").log();
    }
}
