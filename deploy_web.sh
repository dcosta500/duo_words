#!/bin/bash

remote_root="/home/diogo/documents/projects/duo_words/web_app"
image_name="duo-words-nginx"
container_name="$image_name-container"

# Build web version
flutter build web

# Transfer static content (html, js, css, ...)
ssh diogo@pihome.local "rm -r $remote_root/web"
scp -r ./build/web diogo@pihome.local:$remote_root

# Rebuild image from dockerfile
ssh diogo@pihome.local "
cd $remote_root &&\
docker rm -f $container_name &&\
docker rmi duo-words-nginx
"

ssh diogo@pihome.local "
cd $remote_root &&\
docker build -t $image_name . &&\
docker run --name $container_name -p 8081:80 -d $image_name
"