#!/bin/bash

UBUNTU_VER=12.04

if [ -z "$1" ] ; then
   ARCH=i386
else
   ARCH=amd64
fi

if [ ! -f packer.zip ] ; then
  curl -L https://releases.hashicorp.com/packer/1.0.0/packer_1.0.0_linux_amd64.zip?_ga=1.155119281.822261056.1493217676 > packer.zip
  unzip packer.zip
fi

rm -rf packer-ubuntu-${UBUNTU_VER}-${ARCH}-virtualbox
# ako je na silu prosli put prekinuto
VBoxManage controlvm ubuntu-${UBUNTU_VER}-${ARCH} poweroff
VBoxManage unregistervm ubuntu-${UBUNTU_VER}-${ARCH} --delete
VBoxManage unregistervm ubuntu-${UBUNTU_VER}-${ARCH} --delete

rm -rf "/home/docker/VirtualBox VMs/ubuntu-${UBUNTU_VER}-${ARCH}"


chmod +x packer
./packer build -var 'headless=true'  -only=virtualbox-iso ubuntu-${UBUNTU_VER}-${ARCH}.json

if [ $ARCH == "amd64" ] ; then
   mv builds/ubuntu-${UBUNTU_VER}.virtualbox.box ubuntu_desktop_${UBUNTU_VER}_$(date +"%Y-%m-%d").box
else
   mv builds/ubuntu-${UBUNTU_VER}-${ARCH}.virtualbox.box ubuntu_desktop_${UBUNTU_VER}-${ARCH}_$(date +"%Y-%m-%d").box
fi
