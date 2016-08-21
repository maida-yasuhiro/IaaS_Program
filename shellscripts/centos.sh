#bin/bash -x

NAME=$1 # Name
VARIANT=rhel6 # could refer this value on virt-install(1)

CPU=$2 #Number
MEM=$3 #MB
HDD=$4 #GB

sudo setenforce 0


virsh dominfo ${NAME} && \
{ virsh destroy ${NAME}; virsh detach-disk ${NAME} --target vda --persistent && virsh undefine ${NAME}; }

qemu-img create -f qcow2 /var/lib/libvirt/images/${NAME}.img ${HDD}G

virt-install \
    --connect=qemu:///system \
    --name=${NAME} \
    --ram=${MEM} \
    --vcpus=${CPU} \
    --virt-type kvm \
    --hvm           \
    --os-variant=${VARIANT} \
    --disk=path=/var/lib/libvirt/images/${NAME}.img,format=qcow2 \
    --location=/iso/centos67.iso \
    --network=bridge:br0,model=virtio \
    --graphics vnc \
    --serial pty   \
    --console pty  \
    --noautoconsole --wait=-1 \
    --extra-args="ks=http://192.168.1.58/centos.cfg SERVERNAME=${NAME} console=ttyS0,115200"

#finished="0";

#while [ "$finished" = "0" ]; do
 #       sleep 5;
 #       if [ `virsh list --all | grep "running" | grep "${NAME}" | wc -c` -eq 0 ];
 #       then
 #               #echo "setup finished, start vm ${NAME}"
 #               finished=1;
 #               virsh start ${NAME}
 #       fi
#done
