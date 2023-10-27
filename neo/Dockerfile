FROM ubuntu:precise

# CRD/Neo package repos
#COPY sdimg-sources/sources.list /etc/apt/sources.list
#COPY sdimg-sources/sources.list.d /etc/apt/
# OR
COPY ks-sources/sources.list /etc/apt/sources.list
COPY ks-sources/sources.list.d/* /etc/apt/sources.list.d/
# TODO: need to check with mjuarez on which to use
# possibly also need to include ubuntu-toolchain-r-test-precise.list for gcc-4.8 support

# trust local qualcomm pacakge repos
# TODO: replace with apt-key add if possible
COPY trustdb.gpg trusted.gpg /etc/apt/

# crad-docker assumes python is installed in image
RUN apt-get update && apt-get install -y --no-install-recommends python

# grant sudo capability to "users" group
RUN apt-get install -y --no-install-recommends sudo
RUN echo "%users ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers

# Dockerize /afs/qualcomm.com/cm/gv2.6/config/duty/neo.ubuntu.software/neo_ubuntusfwinstall

#SDRD-14207
ADD avante-ubuntu1204-dev-env-0.3b.tgz /usr/local
RUN /bin/chown -R root:41978 /usr/local/avante

#Remove git-man first to insure we are installing the NEO version of git
RUN DEBIAN_FRONTEND=noninteractive apt-get -y -q remove git-man

#SDRD-6397 Removing libopenblas and replacing with libatlas
RUN DEBIAN_FRONTEND=noninteractive apt-get -y -q remove libopenblas-base libopenblas-dev

#Install all required packages
COPY packagelist /tmp/packagelist
RUN DEBIAN_FRONTEND=noninteractive apt-get -y -q install $(cat /tmp/packagelist | /usr/bin/xargs)

#Install Python modules using easy_install per NEO SSIT
COPY pythonmodulelist /tmp/pythonmodulelist
RUN for i in $(cat /tmp/pythonmodulelist); do (cd /tmp/;/usr/bin/easy_install $i);done

#Disabling Apport for standard core file creation
# TODO: this line fails, apport not installed(?)
#RUN /bin/sed -ibak -e s/^enabled\=1$/enabled\=0/ /etc/default/apport

#Final steps
RUN ln -s /lib/x86_64-linux-gnu/libpcre.so.3 /lib/x86_64-linux-gnu/libpcre.so.0

#Added per SDRD-4805
RUN ln -nsf /prj/neoci/releases/zds/modulefiles /usr/share/modules/modulefiles/net-zds
RUN ln -nsf /prj/neoci/releases/nst/modulefiles /usr/share/modules/modulefiles/net-nst
#Added per SDRD-14520
RUN ln -nsf /prj/neoci/releases/ads/modulefiles /usr/share/modules/modulefiles/net-ads

RUN ln -s /usr/share/perl5/vendor_perl /usr/local/lib/site_perl

#SDRD-4852
RUN /usr/sbin/update-alternatives --install /usr/bin/ld ld /usr/bin/ld.gold 1
RUN /usr/sbin/update-alternatives --set ld /usr/bin/ld.gold

#SDRD-7336
# NOTE: this line fails (bash version is now 4.2-2ubuntu2.6)
#RUN /usr/bin/apt-get install -y -q bash=4.2-2ubuntu2.5

#SDRD-7355
RUN ln -nsf /prj/neoci/releases/zdl/modulefiles /usr/share/modules/modulefiles/net-zdl
#SDRD-7709
RUN ln -nsf /prj/neoci/releases/dl/modulefiles /usr/share/modules/modulefiles/net-dl

# END Dockerize /afs/qualcomm.com/cm/gv2.6/config/duty/neo.ubuntu.software/neo_ubuntusfwinstall

# fix environment-module bash completion
# https://crd-jira.qualcomm.com/jira/browse/NEO-13189
RUN rpl -q 'share/modules/3.2.9/' '' /etc/bash_completion.d/modules

# add missing packages
RUN apt-get install -y -q --no-install-recommends less vim lib32z1

# needed by crad-repo
RUN apt-get install -y -q --no-install-recommends python-simplejson

# apply patch to custom git debian package to conform to packaging conventions
# https://crd-jira.qualcomm.com/jira/browse/NEO-17714
COPY update-git.deb git.deb-patch /tmp/
RUN cd /tmp && ./update-git.deb && rm update-git.deb git.deb-patch

# needed by ads-carviz-app on non-nvidia hosts (pulls in additional mesa and xcb dependencies)
RUN apt-get install -y --no-install-recommends mesa-utils-extra

# NVIDIA GPU support
# for testing xeyes/glxgears and xrandr
RUN apt-get install -y --no-install-recommends x11-apps mesa-utils x11-xserver-utils

# nvidia-docker hooks
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /usr/local/nvidia/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

# module load /usr/local/avante/devenv
ENV PATH /usr/local/avante/tools/cmake/bin:/usr/local/avante/tools/python27/bin:/usr/local/avante/tools/bin:${PATH}
ENV PYTHONPATH /usr/local/avante/tools/python27/lib/python2.7/site-packages

# set QT plugin path for GUI apps
ENV QT_QPA_PLATFORM_PLUGIN_PATH /prj/neoci/tools/prebuilt/Qt/x86_64-linux-5.6.0/Qt5.6.0/5.6/gcc_64/plugins/platforms
