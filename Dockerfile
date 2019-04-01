# Why node:9 and not node:10? Because (a) v8 is LTS, so more likely to be stable, and (b) "npm update" on node:10 breaks on Docker on Linux (but not on OSX, oddly)
FROM node:9-slim

# Now we DO need these, for the auto-labeling of the image
ARG BUILD_DATE
ARG VCS_REF

# Good docker practice, plus we get microbadger badges
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.vcs-url="https://github.com/zumcoin/zum-nodejs-pool.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.schema-version="2.2-r1"

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs-legacy npm git libboost1.55-all libssl-dev \
  && rm -rf /var/lib/apt/lists/* 

ADD . /pool/
WORKDIR /pool/

RUN npm update

RUN mkdir -p /config

EXPOSE 8117
EXPOSE 8119
EXPOSE 3333
EXPOSE 5555
EXPOSE 7777

VOLUME ["/config"]

CMD node init.js -config=/config/config.json
