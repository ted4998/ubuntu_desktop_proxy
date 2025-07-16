#!/bin/bash

# Get the VM number from the hostname
VM_NUMBER=$(hostname | sed 's/ubuntu-vm-//')

# Run the configuration script
/root/configure_vm.sh $VM_NUMBER
