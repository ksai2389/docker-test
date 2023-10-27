#!/bin/bash

CRAD_DOCKER_CONFIG=$1

AGENTUSER=omnici

# check that AGENTUSER is running this script
[ $USER == $AGENTUSER ] || { echo >&2 "script must be run by $AGENTUSER, aborting..." ; exit 1; }

PATH=/pkg/crad/python3/bin:$PATH
for PROGRAM in crad-docker docker; do
    command -v $PROGRAM > /dev/null 2>&1 || { echo >&2 "$PROGRAM program not available, aborting..." ; exit 1; }
done

# create persistent data volumes
mkdir -p /local/mnt/workspace/${AGENTUSER}/teamcity/agent/{conf,work,logs,plugins,temp,system,tools}
mkdir -p /local/mnt/workspace/${AGENTUSER}/.ccache

# allocate unique cache dir for crad-docker
CACHEDIR=$(mktemp -d -p /tmp)

CONTAINERNAME=agent
[ -v LSB_JOBID ] && CONTAINERNAME=${CONTAINERNAME}_${LSB_JOBID}

# add --no-tty option for non-interactive LSF/TC jobs
TTY_OPTION=''
[ -v LSB_JOBID ] && [ ! -v LSB_INTERACTIVE ] && TTY_OPTION='--no-tty'

DAEMONIZE='-d'
[ -v LSB_JOBID ] && DAEMONIZE=''

# abort if agent is already running
[ $(docker ps -q -f name=${CONTAINERNAME}$ -f status=running | wc -l) -eq 1 ] && { echo >&2 "agent already running, aborting..."; exit 1; }

# clear non-running agent container if it is there
[ $(docker ps -a -q -f name=${CONTAINERNAME}$ | wc -l) -eq 1 ] && docker rm $CONTAINERNAME

# launch agent
crad-docker --cache ${CACHEDIR} ${DAEMONIZE} -c $(dirname $0)/teamcity.conf --name ${CONTAINERNAME} ${TTY_OPTION} ${CRAD_DOCKER_CONFIG} -- /run-agent.sh