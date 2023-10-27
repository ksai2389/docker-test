#!/bin/bash

set -e

# create service-account specific TeamCity tarball derivative
OUTDIR=$(readlink -f .)
[ -v TEAMCITY_VERSION ] || { echo "using hardcoded server url" ; curl -s -S -k -o buildAgentFull.zip https://omni-bld-tc01:8543/update/buildAgentFull.zip ; }
[ -v TEAMCITY_VERSION ] && { echo "using environment server url" ; curl -s -S -k -o buildAgentFull.zip $SERVER_URL/update/buildAgentFull.zip ; }
TMPDIR=$(mktemp -d)
pushd $TMPDIR
unzip -q -d agent $OUTDIR/buildAgentFull.zip
tar --owner=omnici --group=users -cf $OUTDIR/buildAgent.omnici.tar.gz .
popd
rm -r $TMPDIR
