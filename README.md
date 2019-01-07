# docker-jumpserver

fast deploy [jumpserver](https://github.com/jumpserver/jumpserver) by an all in one docker image.

## Supported tags and respective Dockerfile links   

* [v1.4.6 ,latest (Dockerfile)](https://github.com/geniuscirno/docker-jumpserver/blob/v1.4.6/Dockerfile)

## Usage

### startup

```sh
  docker run -d -p 80:80 -p 2222:2222 geniuscirno/jumpserver:latest
```

### environment

* DB_PASSWD = weakPassword

* SECRET_KEY = '2vym+ky!997d5kkcc64mnz06y1mmui3lut#(^wd=%s_qj$1%x'

* BOOTSTRAP_TOKEN = 'nwv4RdXpM82LtSvmV'

* DEBUG = 0

* LOG_LEVEL = ERROR

### volume

* /opt/jumpserver/data

* /opt/coco/keys

* /var/lib/mysql

* /var/log/supervisor
