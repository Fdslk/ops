#!/bin/bash

docker build -q -t skaffold-webflux-example .

if [ $? -eq 0 ]; then
   echo OK, images created
else
   echo FAIL, image not created
   exit 1
fi
