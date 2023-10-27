FROM docker-registry.qualcomm.com/xrresearch/teamcity:base

ENV JRE_HOME=/usr/lib/jvm/java-11-openjdk-amd64

ARG TC_VERSION

# unpack TC tarball from JetBrains
ADD TeamCity-$TC_VERSION.omnici.tar.gz /opt/

ENV TEAMCITY_DIST=/opt/TeamCity
ENV TEAMCITY_DATA_PATH=$TEAMCITY_DIST/datadir \
    TEAMCITY_TEMP=$TEAMCITY_DIST/temp \
    TEAMCITY_LOGS=$TEAMCITY_DIST/logs

COPY run-server.sh /run-server.sh
VOLUME $TEAMCITY_DATA_PATH \
       $TEAMCITY_TEMP \
       $TEAMCITY_LOGS

CMD ["/run-server.sh"]

# Add QC Intranet CA
ADD https://pki.qualcomm.com/ssl_v2_cert.crt /usr/local/share/ca-certificates
ADD https://pki.qualcomm.com/ssl_v3_cert.crt /usr/local/share/ca-certificates
ADD https://pki.qualcomm.com/ssl_v4_cert.crt /usr/local/share/ca-certificates
RUN update-ca-certificates

# Configure HTTPS/SSL
COPY server.xml $TEAMCITY_DIST/conf/server.xml
COPY web.xml $TEAMCITY_DIST/conf/web.xml

# crad-docker assumes python is installed in image
RUN apt-get update && \
    apt-get install -y --no-install-recommends python && \
    rm -rf /var/lib/apt/lists/*

# set locale
RUN apt-get update && \
    apt-get install -y --no-install-recommends locales && \
    rm -rf /var/lib/apt/lists/* && \
    locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# TC recommends that latest git be locally available to server
RUN apt-get update && \
    apt-get install -y --no-install-recommends gpg dirmngr gpg-agent && \
    echo "deb https://ppa.launchpadcontent.net/git-core/ppa/ubuntu focal main" > /etc/apt/sources.list.d/python.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E1DD270288B4E6030699E45FA1715D88E1DF1F24 && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*