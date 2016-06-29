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

The provisioning script will reboot the VM once it has prepared the build environment, this is so that the kernel-devel
package that was installed will match the running kernel. Once the VM has rebooted, fetch the third party packages.

    $ vagrant ssh
    [vagrant@localhost ~]$ pushd opencontrail_repo                                                         
    [vagrant@localhost ~]$ python ./third_party/fetch_packages.py                                          

Finally either build and generate RPMs or build without generating RPMs:

    [vagrant@localhost ~]$ time scons 2>&1 | tee ~/build.log
    or
    [vagrant@localhost ~]$ rpmbuild -ba tools/packages/rpm/contrail/contrail.spec --define "_sbtop $(pwd)" --define "_kVers $(uname -r)" | tee contrail-rpmbuild.log



Copy RPMs from build server if you generated them. Get the ssh-config from vagrant then use the config to scp the files:

    $ vagrant ssh-config
    $ scp -r -i <vagrant-identity-file> vagrant@<vagrant-hostname>:/home/vagrant/rpmbuild/RPMS .
    $ scp -r -i <vagrant-identity-file> vagrant@<vagrant-hostname>:/home/vagrant/rpmbuild/SRPMS .
