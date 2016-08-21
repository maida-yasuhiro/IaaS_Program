#!/bin/bash -x

NAME=$1 # Name

virsh dominfo ${NAME} && \
{ virsh destroy ${NAME}; virsh detach-disk ${NAME} --target vda --persistent && virsh undefine ${NAME}; }

rm -rf /var/lib/libvirt/images/${NAME}.img


