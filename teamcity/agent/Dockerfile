FROM docker-registry.qualcomm.com/xrresearch/cvc:latest

# curl unzip
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl unzip && \
    rm -rf /var/lib/apt/lists/*

# JRE 11
RUN apt-get update && \
    apt-get install -y --no-install-recommends openjdk-11-jre && \
    rm -rf /var/lib/apt/lists/*
ENV JRE_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# install {mdb,ph}{,field}
COPY mdb /usr/local/bin
COPY ph /usr/local/bin
COPY phfield /usr/local/bin
RUN ln -s /usr/local/bin/phfield /usr/local/bin/mdbfield
# mdbfield requires ksh
RUN apt-get update && \
    apt-get install -y --no-install-recommends ksh && \
    rm -rf /var/lib/apt/lists/*

# install/configure agent
ADD buildAgent.omnici.tar.gz /local/mnt/workspace/omnici/teamcity/
COPY run-agent.sh /run-agent.sh
CMD ["/run-agent.sh"]
ENV CONFIG_FILE=/data/teamcity_agent/conf/buildAgent.properties

# Add QC Intranet CA
ADD https://pki.qualcomm.com/ssl_v2_cert.crt /usr/local/share/ca-certificates
ADD https://pki.qualcomm.com/ssl_v3_cert.crt /usr/local/share/ca-certificates
ADD https://pki.qualcomm.com/ssl_v4_cert.crt /usr/local/share/ca-certificates
RUN update-ca-certificates

# crad-repo support
RUN apt-get update && \
    apt-get install -y --no-install-recommends lsb-release git git-man git-flow openssh-client && \
    rm -rf /var/lib/apt/lists/*

# crad-repo
ADD https://pki.qualcomm.com/qc_root_g2_cert.crt /root/.certs/
RUN apt-get update && \
    apt-get install -y --no-install-recommends python-pip python-setuptools python-wheel python-functools32 && \
    rm -rf /var/lib/apt/lists/* && \
    pip --no-cache-dir install -U pip setuptools && \
    pip -v --no-cache-dir --cert /root/.certs/qc_root_g2_cert.crt install --index-url https://crd-artifactory.qualcomm.com/artifactory/api/pypi/crad-pypi/simple/ cradjira && \
    pip --no-cache-dir install -U git+https://github.qualcomm.com/crad/crad-docker@v2.4.0 && \
    pip --no-cache-dir install -U git+https://github.qualcomm.com/crad/crad-repo@v2.13.3

# rsync
RUN apt-get update && \
    apt-get install -y --no-install-recommends rsync && \
    rm -rf /var/lib/apt/lists/*

# python2-yaml assumed to be available in clang-tidy TC jobs
# TODO: this may not be needed after clang-tidy update
RUN apt-get update && \
    apt-get install -y --no-install-recommends python-yaml && \
    rm -rf /var/lib/apt/lists/*

# install adb and lsusb
RUN apt-get update && \
    apt-get install -y --no-install-recommends android-tools-adb usbutils && \
    rm -rf /var/lib/apt/lists/*

# install docker
RUN apt-get update && \
    apt-get install -y --no-install-recommends gnupg2 && \
    rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -sc) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && \
    apt-get install -y --no-install-recommends docker-ce-cli docker-compose-plugin && \
    rm -rf /var/lib/apt/lists/*

# install sfreg py3 env
# python 3.10
RUN apt-get update && \
    apt-get install -y --no-install-recommends gpg dirmngr gpg-agent && \
    echo "deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu bionic main" > /etc/apt/sources.list.d/python.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F23C5A6CF475977595C89F51BA6932366A755776 && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends python3.10 python3.10-venv python3.10-dev gcc && \
    rm -rf /var/lib/apt/lists/*

# video and image processing tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg imagemagick optipng && \
        rm -rf /var/lib/apt/lists/*

# our python scripts look for /usr/bin/env python3
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 10
RUN python3.10 -m ensurepip --default-pip

# latest virtualenv
ADD requirements.txt /
RUN python3.10 -m pip --no-cache-dir install -U pip
RUN pip3.10 --no-cache-dir install wheel
RUN dpkg -P --force-depends python3-yaml
RUN pip3.10 --no-cache-dir install -r /requirements.txt