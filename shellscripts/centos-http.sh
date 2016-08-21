#!/bin/bash -x

NAME=centos-http
VARIANT=rhel6 # could refer this value on virt-install(1)

CPU=2
MEM=1024 #MB
HDD=20   #GB

sudo setenforce 0


virsh dominfo ${NAME} && \
{ virsh destroy ${NAME}; virsh detach-disk ${NAME} --target vda --persistent && virsh undefine ${NAME}; }

qemu-img create -f qcow2 /var/lib/libvirt/images/${NAME}.img 20G

virt-install \
    --connect=qemu:///system \
    --name=${NAME} \
    --ram=${MEM} \
    --vcpus=${CPU} \
    --virt-type kvm \
    --hvm           \
    --os-variant=${VARIANT} \
    --disk=path=/var/lib/libvirt/images/${NAME}.img,format=qcow2 \
    --location=/iso/CentOS-6.7-x86_64-bin-DVD1.iso \
    --network=bridge:br0,model=virtio \
    --nographics \
    --initrd-inject=/centos6-http.cfg \
    --extra-args="ks=file:/centos6-http.cfg  console=tty0 console=ttyS0,115200n8"
