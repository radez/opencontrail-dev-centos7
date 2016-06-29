#!/usr/bin/env bash
set -e

sudo yum clean all
echo "yum update -y -q"
sudo yum update -y -q

## install epel repo, but keep it disabled by default
sudo yum install -y epel-release
sudo sed -i -e 's/enabled=1/enabled=0/' /etc/yum.repos.d/epel.repo

# install packages that are in epel (i.e. not part of centos standard repo)
sudo yum install -y --enablerepo="epel" scons protobuf protobuf-devel protobuf-compiler libpcap libpcap-devel

# install centos packages
sudo yum install -y git python-lxml wget gcc patch make unzip flex bison gcc-c++ openssl-devel autoconf automake vim python-devel python-setuptools python-sphinx

# install centos packages that were not needed in centos 6.x, but are needed on centos 7
sudo yum install -y libtool kernel-devel bzip2 boost-devel tbb-devel libcurl-devel libxml2-devel zlib-devel

# install other missing deps
sudo yum install -y cyrus-sasl-devel

# install rpm-build and other deps to build the datastax driver
sudo yum install -y --enablerepo epel rpm-build cmake libuv-devel libuv

# install deps to build libzookeeper
sudo yum install -y rpmdevtools cppunit-devel

# download and install dependencies
wget http://sourceforge.net/projects/libipfix/files/libipfix/libipfix_110209.tgz
tar xzf libipfix_110209.tgz
pushd libipfix_110209
./configure
make
sudo make install
popd

wget https://github.com/edenhill/librdkafka/archive/0.9.1.tar.gz
tar xzf 0.9.1.tar.gz
pushd librdkafka-0.9.1
./configure
make
sudo make install
popd

# NOT NEEDED
# WILL REMOVE IF MY BUILD SUCCEEDS
#cat << EOF | sudo tee /etc/yum.repos.d/datastax.repo
#[datastax]                                                                      
#name = DataStax Repo for Apache Cassandra                                       
#baseurl = http://rpm.datastax.com/community                                     
#enabled = 1                                                                     
#gpgcheck = 0
#EOF

# build the datastax driver
git clone https://github.com/datastax/cpp-driver
pushd cpp-driver/packaging
./build_rpm.sh
sudo yum install -y build/RPMS/x86_64/*
popd

# build libzookeeper
git clone https://github.com/skottler/zookeeper-rpms
pushd zookeeper-rpms
rpmdev-setuptree
spectool -g zookeeper.spec
rpmbuild -ba --nodeps --define "_sourcedir $(pwd)" --define "_srcrpmdir $(pwd)" zookeeper.spec
sudo yum install -y ~/rpmbuild/RPMS/x86_64/libzookeeper*
popd

# sync contrail repos
curl https://storage.googleapis.com/git-repo-downloads/repo > ./repo && chmod a+x ./repo
mkdir opencontrail_repo
pushd  opencontrail_repo
../repo init -u https://github.com/Juniper/contrail-vnc
sed -i '/<remote name="github"/c\<remote name="github" fetch="https:\/\/github.com\/Juniper"\/>' .repo/manifests/default.xml
../repo sync
popd

sudo reboot
