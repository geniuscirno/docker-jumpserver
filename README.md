# docker-jumpserver

fast deploy [jumpserver](https://github.com/jumpserver/jumpserver) by an all in one docker image.

## Usage

### startup

```sh
  docker run -d -p 80:80 -p 2222:2222 geniuscirno/jumpserver:latest
```

### environment

* SECRET_KEY

* BOOTSTRAP_TOKEN

* DEBUG

* LOG_LEVEL

### volume
