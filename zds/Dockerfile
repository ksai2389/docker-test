FROM ubuntu:precise

# backports need to be enabled for newer ipython packages (needed by zds)
COPY backports.list /etc/apt/sources.list.d/backports.list

# ZDS dependencies
RUN apt-get update && apt-get install -y --no-install-recommends debhelper tcl8.5 chromium-browser libpython2.7 libx11-6 libx11-xcb1 libxau6 libxcb-glx0 libxcb1 libxdamage1 libxdmcp6 libxext6 libxfixes3 libxrandr2 libxrender1 ipython=0.13.2-1~ubuntu12.04.2 ipython-notebook=0.13.2-1~ubuntu12.04.2 libxxf86vm1 python-matplotlib python-numpy python-scipy g++ gcc && rm -rf /var/lib/apt/lists/*

COPY debs /tmp/debs
RUN dpkg -i /tmp/debs/environment-modules_*.deb

ENV ZDS_VERSION 1.1.0.60
RUN dpkg -i /tmp/debs/zds-${ZDS_VERSION}.deb
RUN rm -rf /tmp/debs

ENV ZDS_ROOT /opt/qualcomm/zeroth/zds-${ZDS_VERSION}
ENV LD_LIBRARY_PATH ${ZDS_ROOT}/lib
ENV PATH ${ZDS_ROOT}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PYTHONPATH ${ZDS_ROOT}/lib/python
