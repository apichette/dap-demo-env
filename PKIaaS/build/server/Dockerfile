FROM nginx

RUN    apt-get update -y  \
    && apt-get install -y \
	openssl \
	jq \
	curl \
    && mkdir /conjur

ADD tls* /conjur/
ADD nginx.conf /etc/nginx/conf.d/server.conf
