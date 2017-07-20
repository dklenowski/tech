#!/bin/bash


docker build -rm -t registry.ecg.so/gtau/httpd_2.4:prod httpd-2.4/ 
docker push registry.ecg.so/gtau/httpd_2.4:prod
