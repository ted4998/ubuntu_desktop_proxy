#!/bin/bash

# This script provisions 10 Ubuntu virtual machines using `virt-install`.

# Set the number of VMs to create.
NUM_VMS=10

# Set the path to the Ubuntu 22.04 ISO image.
#
# **Important:** You must download the Ubuntu 22.04 Desktop ISO image from the
# official website and update this variable to the correct path.
ISO_PATH="/path/to/ubuntu-22.04-desktop-amd64.iso"

# Check if the ISO file exists.
if [ ! -f "$ISO_PATH" ]; then
    echo "Error: ISO file not found at $ISO_PATH"
    echo "Please download the Ubuntu 22.04 Desktop ISO and update the ISO_PATH variable in this script."
    exit 1
fi

# Loop to create the VMs.
for i in $(seq 1 $NUM_VMS)
do
    # Set the VM name.
    VM_NAME="ubuntu-vm-$i"

    # Generate a random MAC address for the VM.
    MAC_ADDRESS=$(printf '52:54:00:%02X:%02X:%02X\n' $[RANDOM%256] $[RANDOM%256] $[RANDOM%256])

    echo "Creating VM: $VM_NAME"

    # Create the VM using `virt-install`.
    #
    # - --name: The name of the VM.
    # - --ram: The amount of RAM to allocate to the VM (in MB).
    # - --vcpus: The number of virtual CPUs to allocate to the VM.
    # - --disk: The path to the VM's disk image and the size of the disk (in GB).
    # - --os-variant: The operating system variant of the VM.
    # - --network: The network configuration for the VM.
    # - --graphics: The graphics configuration for the VM.
    # - --noautoconsole: Do not automatically connect to the VM's console.
    # - --cdrom: The path to the ISO image to use for the installation.
    # - --initrd-inject: Inject files into the initrd of the installer.
    # - --extra-args: Pass extra arguments to the kernel.
    virt-install \
        --name $VM_NAME \
        --ram 2048 \
        --vcpus 2 \
        --disk path=/var/lib/libvirt/images/$VM_NAME.qcow2,size=20 \
        --os-variant ubuntu22.04 \
        --network bridge=virbr0,mac=$MAC_ADDRESS \
        --graphics vnc,listen=0.0.0.0 \
        --noautoconsole \
        --cdrom $ISO_PATH \
        --initrd-inject configure_vm.sh \
        --initrd-inject firstboot.sh \
        --extra-args "console=ttyS0,115200n8" &
done

# Inform the user that the VM creation process has started.
echo "VM creation process started. It may take some time for all VMs to be created."
echo "You can check the status of the VMs using the 'virsh list --all' command."
