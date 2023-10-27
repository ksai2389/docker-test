# Build instructions
## Server build
    cd server
    ./create_ssl_cert.sh <hostname> <subjectalternativename>
    # go/sslca to generate QC signed cert
    # add cert to java keystore
    # SSLHOSTNAME=omni-bld-tc01
    # SSLHOSTNAMEFQDN=${SSLHOSTNAME}.qualcomm.com
    openssl pkcs12 -export -in ${SSLHOSTNAMEFQDN}.crt -inkey ${SSLHOSTNAMEFQDN}.key -out ${SSLHOSTNAMEFQDN}.p12 -name ${SSLHOSTNAME} -passout pass:omnissl
    keytool -importkeystore -destkeystore ${SSLHOSTNAMEFQDN}.keystore -srckeystore ${SSLHOSTNAMEFQDN}.p12 -srcstoretype PKCS12 -alias ${SSLHOSTNAME} -srcstorepass omnissl -deststorepass omnissl
    # edit/add keystoreFile references
    vim server.xml
    # create service-account specific TeamCity tarball derivative
    OUTDIR=$(readlink -f .)
    VERSION=2021.1.4
    wget https://download.jetbrains.com/teamcity/TeamCity-${VERSION}.tar.gz
    TMPDIR=$(mktemp -d)
    cd $TMPDIR
    tar xf $OUTDIR/TeamCity-${VERSION}.tar.gz
    tar --owner=omnici --group=users -cf $OUTDIR/TeamCity-${VERSION}.omnici.tar.gz .
    cd $OUTDIR/..
    rm -r $TMPDIR

## Agent build
    cd agent
    # create service account specific TeamCity Agent tarball derivative
    # also tweak conf location for compatibility with upstream run_agent.sh docker cmd
    curl -k -o buildAgentFull.zip https://omni-bld-tc01:8543/update/buildAgentFull.zip
    OUTDIR=$(readlink -f .)
    TMPDIR=$(mktemp -d)
    cd $TMPDIR
    unzip -q -d agent $OUTDIR/buildAgentFull.zip
    tar --owner=omnici --group=users -cf $OUTDIR/buildAgent.omnici.tar.gz .
    cd $OUTDIR/..
    rm -r $TMPDIR

## General (docker) build
    ./register.sh

# Installation instructions
## Server installation

    # make data dirs for teamcity and mysql servers
    mkdir -p /local/mnt/workspace/teamcity/{datadir/lib/jdbc,datadir/keys,logs,db,dbconf}
    # add mysql plugin to teamcity datadir
    TMPDIR=$(mktemp -d)
    cd $TMPDIR
    wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.42.tar.gz
    tar xf mysql-connector-java-5.1.42.tar.gz mysql-connector-java-5.1.42/mysql-connector-java-5.1.42-bin.jar
    mv mysql-connector-java-5.1.42/mysql-connector-java-5.1.42-bin.jar /local/mnt/workspace/teamcity/datadir/lib/jdbc
    cd -
    rm -r $TMPDIR
    # add db config file
    cp -a db/teamcity.cnf /local/mnt/workspace/teamcity/dbconf

## Agent installation

    # make data dirs for teamcity agent
    mkdir -p /local/mnt/workspace/omnici/teamcity/agent/{conf,work,logs}

### Windows agent installation

Download and install Agent Installer MSI from TeamCity server.
Download [ssl_v2_cert.crt](https://pki.qualcomm.com/ssl_v2_cert.crt) from [go/qcssl](http://go/qcssl).
Add QC SSL key to Agent JRE:

    cd \BuildAgent
    jre\bin\keytool.exe -import -trustcacerts -file C:\Users\omnici\Downloads\ssl_v2_cert.crt -keystore jre\lib\security\cacerts -storepass changeit

# Startup instructions (as omnici)

    # start TC DB (on omni-bld-tc03)
    crad-docker -d -c /prj/omnilin/users/omnici/dockers-repo/teamcity/teamcity.conf db -- /entrypoint.sh mysqld
    # start TC Server (on omni-bld-tc03)
    crad-docker -d -c /prj/omnilin/users/omnici/dockers-repo/teamcity/teamcity.conf server -- /run-server.sh
    # start TC Agent (on build agents, e.g., omni-bld-lin1 - lin10)
    crad-docker -d --name agent -c /prj/omnilin/users/omnici/dockers-repo/teamcity/teamcity.conf agent -- /run-agent.sh
    # start TC Agent with USB tethering (adb) support (on athars-linux-2 et al.)
    crad-docker -d --name agent -c /prj/omnilin/users/omnici/dockers-repo/teamcity/teamcity.conf agent-tethered -- /run-agent.sh

## Startup agent on LSF

    su - omnici
    # crd-lsf-681 - crd-lsf-690 refers to crd hostnames in docker/jci pool, see output of "bhosts -w allocated_jci"
    for NODE in {681..690}; do bsub -R "select[docker && ubuntu]" -g /omnici/LSFCIAgent -m crd-lsf-${NODE} /prj/omnilin/users/omnici/dockers-repo/teamcity/lsfAgentLaunch.sh; done

## Server Migration

    rsync -a --del  /local/mnt/workspace/teamcity/  new-server:/local/mnt/workspace/teamcity


### Startup agent on Windows

    cd \BuildAgent\bin
    agent.bat start

# Shutdown instructions

    # stop TC Agent
    docker stop agent && docker rm agent
    # stop TC Server
    docker stop server_${USER} && docker rm server_${USER}
    # stop TC DB
    docker stop db_${USER} && docker rm db_${USER}

## Windows agent shutdown

    cd \BuildAgent\bin
    agent.bat stop

## LSF agent shutdown

    bkill -g /omnici/LSFCIAgent 0

# Automated server backups
Added the following REST API call to the omnici crontab on omni-bld-tc01, see [stackoverflow](https://stackoverflow.com/questions/10548726/how-to-schedule-automatic-backups-in-teamcity) for detailed discussion:

    docker exec -it server_omnici curl --basic --user 'omnici:<OMNICIPW>' -X POST "https://omni-bld-tc01:8543/httpAuth/app/rest/server/backup?addTimestamp=true&includeConfigs=true&includeDatabase=true&includeBuildLogs=true&includePersonalChanges=true&fileName=TeamCity_Backup"


# References

[server/run_server.sh](https://github.com/JetBrains/teamcity-docker-server/blob/master/run-server.sh)

[TC HTTPS/SSL issue with links to solutions](https://youtrack.jetbrains.com/issue/TW-12976)

Notes regarding usage of [keytool](http://stackoverflow.com/a/8224863) and [openssl](https://superuser.com/a/724987) commands

MySQL [config tweak](https://confluence.jetbrains.com/display/TCD9/How+To...#HowTo...-innodb_flush_log_at_trx_commit) recommended for teamcity performance, see [db/teamcity.cnf](db/teamcity.cnf)
