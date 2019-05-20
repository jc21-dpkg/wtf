#!/bin/bash -e

sudo apt-get install -y  wget make devscripts

PACKAGE=wtf
GH_USER=wtfutil
VERSION=`cat version`

# Clean
rm -rf ${PACKAGE}-${VERSION}

# Download
if [ -e "${PACKAGE}_${VERSION}.orig.tar.gz" ]; then
    echo "${PACKAGE}_${VERSION}.orig.tar.gz exists, skipping.."
else
    wget -nv https://github.com/${GH_USER}/${PACKAGE}/archive/v${VERSION}.tar.gz
    mv -f v${VERSION}.tar.gz ${PACKAGE}_${VERSION}.orig.tar.gz
fi

# Extract
tar xzf ${PACKAGE}_${VERSION}.orig.tar.gz

# Copy over debian package info
cp -pr debian ${PACKAGE}-${VERSION}/

# Build
cd ${PACKAGE}-${VERSION}
sudo mk-build-deps --install --tool='apt-get --no-install-recommends -y' debian/control
dpkg-buildpackage --sign-key=EFD591B218E19AE3376D80D14F9E050D1DFFBB86 --force-sign
