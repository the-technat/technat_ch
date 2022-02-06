############################
# STEP 1 build site 
############################
FROM alpine:3 as builder

ARG HUGO_VERSION
WORKDIR /tmp/site/

## Install hugo
RUN cd /tmp && \
  wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz -O hugo.tar.gz && \
  tar -vxzf hugo.tar.gz && \
  mv hugo /sbin/hugo

## Build site
COPY . .
RUN hugo -D

############################
# STEP 2 build small static webserver
############################
FROM nginx:stable-alpine 

# Get static site into webroot
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /tmp/site/public /usr/share/nginx/html/
