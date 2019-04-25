ARG TEI_PUBLISHER_LIB_VERSION=2.7.0

# START STAGE 1
FROM openjdk:8-jdk-slim as builder

USER root

ENV TEI_PUBLISHER_APP_VERSION 4.1.0
ENV ANT_VERSION 1.10.5
ENV ANT_HOME /etc/ant-${ANT_VERSION}

WORKDIR /tmp

RUN apt-get update && apt-get install -y \
 git \
 ant \
 wget

RUN wget http://www-us.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
    && mkdir ant-${ANT_VERSION} \
    && tar -zxvf apache-ant-${ANT_VERSION}-bin.tar.gz \
    && mv apache-ant-${ANT_VERSION} ${ANT_HOME} \
    && rm apache-ant-${ANT_VERSION}-bin.tar.gz \
    && rm -rf ant-${ANT_VERSION} \
    && rm -rf ${ANT_HOME}/manual \
    && unset ANT_VERSION

ENV PATH ${PATH}:${ANT_HOME}/bin

# Build tei app
# we should make a seperate container from this. TRhere is no tei container yet.
FROM builder as tei
# add key
RUN  mkdir -p ~/.ssh && ssh-keyscan -t rsa gitlab.existsolutions.com >> ~/.ssh/known_hosts
RUN  git clone https://gitlab.existsolutions.com/tei-publisher/tei-publisher-app.git \
 && cd tei-publisher-app \
 && git checkout ${TEI_PUBLISHER_APP_VERSION} \
 && ant

# Build final container
FROM tobinski/tei-publisher-lib:${TEI_PUBLISHER_LIB_VERSION}
COPY --from=tei /tmp/tei-publisher-app/build/*.xar /exist/autodeploy
