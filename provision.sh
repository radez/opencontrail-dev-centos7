#!/usr/bin/env bash

echo "yum update -y -q"
yum update -y -q

## install epel repo, but keep it disabled by default
yum install -y https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm
sed -i -e 's/enabled=1/enabled=0/' /etc/yum.repos.d/epel.repo

# install packages that are in epel (i.e. not part of centos standard repo)
yum install -y --disablerepo="*" --enablerepo="epel" scons protobuf protobuf-devel protobuf-compiler

# install centos packages
yum install -y git python-lxml wget gcc patch make unzip flex bison gcc-c++ openssl-devel autoconf automake vim python-devel python-setuptools  

# install centos packages that were not neede in centos 6.x, but are needed on centos 7
yum install -y libtool kernel-devel bzip2 boost-devel tbb-devel libcurl-devel libxml2-devel

echo "***********************************************************"
echo "*  PREPARE opencontrail repo and RELOAD THIS VAGRANT BOX  *"
echo "*  These steps are listed in the README.md file.          *"
echo "***********************************************************"
