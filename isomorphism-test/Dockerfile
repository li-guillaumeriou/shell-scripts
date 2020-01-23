FROM golang:rc-alpine3.11

RUN apk update \
    && apk add jq \
    && apk add curl \
    && apk add bash \
    && apk add git \
    && rm -rf /var/cache/apk/* \
    && go get github.com/ericchiang/pup 

RUN mkdir /scripts

COPY ./ /scripts

RUN chmod +x /scripts/testUserAgent.sh
WORKDIR /scripts
ENTRYPOINT [ "./testUserAgent.sh" ]