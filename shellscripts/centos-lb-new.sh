#bin/bash -x

############ Version 0.1 2016/02/05
NAME=$1 # Name
VARIANT=rhel6 # could refer this value on virt-install(1)

CPU=$2 #Number
MEM=$3 #MB
HDD=$4 #GB
USERNAME=$5 #User name
PASS=$6     #Password

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
    --extra-args="ks=http://192.168.1.58/centos-lb-new.cfg SERVERNAME=${NAME} USER=${USERNAME} ksdevice=eth0 console=ttyS0,115200"



######

ssh root@192.168.1.20 htpasswd -b /etc/httpd/.htpass ${USERNAME} ${PASS}

cat << EOF > /root/web-conf/${USERNAME}.conf
<Directory "/var/www/html/key/${USERNAME}">
    AuthUserFile /etc/httpd/.htpass
    AuthType Basic
    AuthName ByPassword
   <Limit GET POST>
     require user ${USERNAME}
   </Limit>
</Directory>
EOF

scp /root/web-conf/*.conf 192.168.1.20:/etc/httpd/conf.d/

#rm -rf /root/web-conf/*.conf

#ssh root@192.168.1.20 service httpd reload

#######

