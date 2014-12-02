opencontrail-dev-centos7
========================

Use vagrant to setup centos 7 box for building opencontrail.
The initial version simply follows the guidelines found in the quick start guide on
http://juniper.github.io/contrail-vnc/README.html

How to use it:

Clone this git repository:

    $ git clone https://github.com/flavio-fernandes/opencontrail-dev-centos7.git && cd opencontrail-dev-centos7

This will create the following files:

    $ ls
    README.md	Vagrantfile	provision.sh

Bring up the virtual machine for the very first time:

    $ vagrant up

Follow the steps in http://juniper.github.io/contrail-vnc/README.html and
make a repo that can be used from the vagrant vm.

   $ curl https://storage.googleapis.com/git-repo-downloads/repo > ./repo && chmod a+x ./repo

   $ mkdir opencontrail_repo && cd opencontrail_repo ; \
     ../repo init -u git@github.com:Juniper/contrail-vnc && ../repo sync

   $ cd .. && tar czf opencontrail_repo.tgz opencontrail_repo && rm -rf opencontrail_repo

Restart vagrant box. When its up, it will contain the repo tarball in /vagrant

   $ vagrant reload ; vagrant ssh

   [vagrant@localhost ~]$ tar xzf /vagrant/opencontrail_repo.tgz && cd opencontrail_repo

Build opencontrail

   [vagrant@localhost opencontrail_repo]$ python ./third_party/fetch_packages.py ; echo $?   

   [vagrant@localhost opencontrail_repo]$ time scons 2>&1 | tee ~/build.log ; echo $?
