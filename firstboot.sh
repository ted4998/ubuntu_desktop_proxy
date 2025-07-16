#!/bin/bash

# This script is run on the first boot of a newly provisioned VM.

# Get the VM number from the hostname.
# The hostname is set to `ubuntu-vm-N` by the `provision_vms.sh` script,
# where `N` is the VM number.
VM_NUMBER=$(hostname | sed 's/ubuntu-vm-//')

# Run the configuration script, passing the VM number as an argument.
/root/configure_vm.sh $VM_NUMBER
