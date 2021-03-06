#!/bin/bash

if [ -z "$1" ] ; then
   ARCH=i386
else
   ARCH=amd64
fi

if [ ! -f packer.zip ] ; then
  curl -L https://releases.hashicorp.com/packer/1.0.0/packer_1.0.0_linux_amd64.zip?_ga=1.155119281.822261056.1493217676 > packer.zip
  unzip packer.zip
fi

rm -rf packer-ubuntu-16.04-${ARCH}-virtualbox
# ako je na silu prosli put prekinuto
VBoxManage controlvm ubuntu-16.04-${ARCH} poweroff
VBoxManage unregistervm ubuntu-16.04-${ARCH} --delete
VBoxManage unregistervm ubuntu-16.04-${ARCH} --delete

rm -rf "/home/docker/VirtualBox VMs/ubuntu-16.04-${ARCH}"


chmod +x packer
./packer build -var 'headless=true'  -only=virtualbox-iso ubuntu-16.04-${ARCH}.json

if [ $ARCH == "amd64" ] ; then
   mv builds/ubuntu-16.04.virtualbox.box ubuntu_16.04_$(date +"%Y-%m-%d").box
else
   mv builds/ubuntu-16.04-${ARCH}.virtualbox.box ubuntu_16.04-${ARCH}_$(date +"%Y-%m-%d").box
fi
