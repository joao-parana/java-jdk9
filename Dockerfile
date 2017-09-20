FROM buildpack-deps:sid-scm
# FROM debian:latest
# FROM debian:sid

# FROM buildpack-deps:sid-curl
# buildpack-deps:sid-curl is a Debian sid (unstable)
# with ca-certificates, curl and wget

#
# based on oficial version java:openjdk-9-b181 avaiable
# in https://hub.docker.com/_/openjdk/
#

MAINTAINER João Antonio Ferreira "joao.parana@gmail.com"

ENV REFRESHED_AT 2017-09-20

# A few reasons for installing distribution-provided OpenJDK:
#
#  1. Oracle.  Licensing prevents us from redistributing the official JDK.
#
#  2. Compiling OpenJDK also requires the JDK to be installed, and it gets
#     really hairy.
#
#     For some sample build times, see Debian's buildd logs:
#       https://buildd.debian.org/status/logs.php?pkg=openjdk-9

RUN apt-get update && apt-get install -y --no-install-recommends \
    bzip2 \
    unzip \
    xz-utils \
  && rm -rf /var/lib/apt/lists/*

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
    echo '#!/bin/sh'; \
    echo 'set -e'; \
    echo; \
    echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
  } > /usr/local/bin/docker-java-home \
  && chmod +x /usr/local/bin/docker-java-home

# do some fancy footwork to create a JAVA_HOME that's cross-architecture-safe
RUN ln -svT "/usr/lib/jvm/java-9-openjdk-$(dpkg --print-architecture)" /docker-java-home
ENV JAVA_HOME /docker-java-home

ENV JAVA_VERSION 9-b181
ENV JAVA_DEBIAN_VERSION 9~b181-4

RUN set -ex; \
  \
# deal with slim variants not having man page directories (which causes "update-alternatives" to fail)
  if [ ! -d /usr/share/man/man1 ]; then \
    mkdir -p /usr/share/man/man1; \
  fi; \
  \
  apt-get update; \
  apt-get install -y \
    openjdk-9-jdk="$JAVA_DEBIAN_VERSION" \
  ; \
  rm -rf /var/lib/apt/lists/*; \
  \
# verify that "docker-java-home" returns what we expect
  [ "$(readlink -f "$JAVA_HOME")" = "$(docker-java-home)" ]; \
  \
# update-alternatives so that future installs of other OpenJDK versions don't change /usr/bin/java
  update-alternatives --get-selections | awk -v home="$(readlink -f "$JAVA_HOME")" 'index($3, home) == 1 { $2 = "manual"; print | "update-alternatives --set-selections" }'; \
# ... and verify that it actually worked for one of the alternatives we care about
  update-alternatives --query java | grep -q 'Status: manual'

WORKDIR /playground

# https://docs.oracle.com/javase/9/tools/jshell.htm
# https://en.wikipedia.org/wiki/JShell
# CMD ["jshell"]

RUN echo "••• Run jshell to play with Java 9 •••"

CMD ["bash"]
