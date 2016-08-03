FROM debian:sid

# FROM buildpack-deps:sid-curl
# buildpack-deps:sid-curl is a Debian sid (unstable)
# with ca-certificates, curl and wget

#
# based on oficial version java:openjdk-9-b96 avaiable
# in https://hub.docker.com/r/library/java/tags/
#

MAINTAINER João Antonio Ferreira "joao.parana@gmail.com"

ENV REFRESHED_AT 2016-07-26

# A few problems with compiling Java from source:
#  1. Oracle.  Licensing prevents us from redistributing the official JDK.
#  2. Compiling OpenJDK also requires the JDK to be installed, and it gets
#       really hairy.

RUN echo 'deb http://httpredir.debian.org/debian experimental main' > /etc/apt/sources.list.d/experimental.list

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

ENV JAVA_VERSION 9~b124
ENV JAVA_DEBIAN_VERSION 9~b124-1

# see https://bugs.debian.org/775775
# and https://github.com/docker-library/java/issues/19#issuecomment-70546872
# ENV CA_CERTIFICATES_JAVA_VERSION 20140324

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       ca-certificates curl openjdk-9-jdk="$JAVA_DEBIAN_VERSION" \
    && rm -rf /var/lib/apt/lists/* ; \
       ls -la /var/cache/apt/archives ; find /var/cache/apt/archives

# see CA_CERTIFICATES_JAVA_VERSION notes above
RUN /var/lib/dpkg/info/ca-certificates-java.postinst configure

# see https://bugs.debian.org/793210
# and https://github.com/docker-library/java/issues/46#issuecomment-119026586
RUN apt-get update \
    && apt-get install -y --no-install-recommends libfontconfig1 \
    && rm -rf /var/lib/apt/lists/*

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
    echo '#!/bin/sh'; \
    echo 'set -e'; \
    echo; \
    echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
  } > /usr/local/bin/docker-java-home \
  && chmod +x /usr/local/bin/docker-java-home

ENV JAVA_HOME /usr/lib/jvm/java-9-openjdk-amd64

# If you're reading this and have any feedback on how this image could be
# improved, please open an issue or a pull request so we can discuss it!

WORKDIR /playground

CMD ["bash"]
