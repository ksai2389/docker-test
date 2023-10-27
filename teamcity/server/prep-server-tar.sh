#!/bin/bash

set -e

# create service-account specific TeamCity tarball derivative
OUTDIR=$(readlink -f .)
VERSION=$1
wget -q https://download.jetbrains.com/teamcity/TeamCity-${VERSION}.tar.gz
TMPDIR=$(mktemp -d)
pushd $TMPDIR
tar xf $OUTDIR/TeamCity-${VERSION}.tar.gz
tar --owner=omnici --group=users -cf $OUTDIR/TeamCity-${VERSION}.omnici.tar.gz .
popd
rm -r $TMPDIR
