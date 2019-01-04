FROM ubuntu:18.04

ENV JUMPSERVER_VER=1.4.6 \
    LUNA_VER=1.4.6 \
    GUACAMOLE_VER=0.9.14

RUN  apt-get update \
    && apt-get -y install wget gcc libffi-dev git libmysqlclient-dev language-pack-zh-hans \
     software-properties-common mysql-server redis-server nginx supervisor \
    && export LC_ALL=zh_CN.UTF-8 \
    && echo 'LANG="zh_CN.UTF-8"' > /etc/default/locale \
    && add-apt-repository ppa:jonathonf/python-3.6 -y \
    && apt-get update \
    && apt-get -y install python3.6 python3.6-dev python3.6-venv python3-pip


RUN cd /opt  && git clone https://github.com/jumpserver/jumpserver.git \
    && cd /opt/jumpserver && git checkout ${JUMPSERVER_VER} \
    && cd /opt/jumpserver/requirements && DEBIAN_FRONTEND=noninteractive apt-get -y install $(cat deb_requirements.txt) \
    && ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive tzdata

RUN bash -c "cd /opt && python3 -m venv py3 \
    && source /opt/py3/bin/activate \
    && pip install --upgrade pip setuptools \
    && cd /opt/jumpserver/requirements && pip install -r requirements.txt \
    && deactivate"

RUN bash -c "source /opt/py3/bin/activate \
    && git clone https://github.com/jumpserver/coco.git /opt/coco && cd /opt/coco && git checkout master \
    && cd /opt/coco/requirements \
    && pip install -r requirements.txt "

RUN cd /tmp && wget https://github.com/jumpserver/luna/releases/download/${LUNA_VER}/luna.tar.gz \
    && tar zxvf /tmp/luna.tar.gz -C /opt \
    && chown -R root:root /opt/luna \
    && rm -rf /tmp/luna.tar.gz

RUN mkdir -p /var/lib/mysql /var/run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
    && chmod 777 /var/run/mysqld

COPY config.py /opt/jumpserver/config.py
COPY config.py /opt/coco/conf.py
COPY jumpserver.conf /etc/nginx/sites-available/default
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY docker-entrypoint.sh /usr/local/bin

ENV DB_PASSWD=weakPassword \
    SECRET_KEY='2vym+ky!997d5kkcc64mnz06y1mmui3lut#(^wd=%s_qj$1%x' \
    BOOTSTRAP_TOKEN='nwv4RdXpM82LtSvmV' \
    DEBUG=0 \
    LOG_LEVEL=ERROR

VOLUME /opt/jumpserver/data
VOLUME /opt/coco/keys
VOLUME /var/lib/mysql
VOLUME /var/log/supervisor

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
