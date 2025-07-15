#!/bin/bash

# Number of VMs to create
NUM_VMS=10

# Path to the Ubuntu 22.04 ISO image
ISO_PATH="/path/to/ubuntu-22.04-desktop-amd64.iso"

# Check if the ISO file exists
if [ ! -f "$ISO_PATH" ]; then
    echo "Error: ISO file not found at $ISO_PATH"
    echo "Please download the Ubuntu 22.04 Desktop ISO and update the ISO_PATH variable in this script."
    exit 1
fi

# Loop to create the VMs
for i in $(seq 1 $NUM_VMS)
do
    VM_NAME="ubuntu-vm-$i"
    MAC_ADDRESS=$(printf '52:54:00:%02X:%02X:%02X\n' $[RANDOM%256] $[RANDOM%256] $[RANDOM%256])

    echo "Creating VM: $VM_NAME"

    virt-install \
        --name $VM_NAME \
        --ram 2048 \
        --vcpus 2 \
        --disk path=/var/lib/libvirt/images/$VM_NAME.qcow2,size=20 \
        --os-variant ubuntu22.04 \
        --network bridge=virbr0,mac=$MAC_ADDRESS \
        --graphics vnc,listen=0.0.0.0 \
        --noautoconsole \
        --cdrom $ISO_PATH &
done

echo "VM creation process started. It may take some time for all VMs to be created."
echo "You can check the status of the VMs using the 'virsh list --all' command."
