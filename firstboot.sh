#!/bin/bash

# This script is run on the first boot of a newly provisioned VM.

# Get the VM number from the hostname.
# The hostname is set to `ubuntu-vm-N` by the `provision_vms.sh` script,
# where `N` is the VM number.
VM_NUMBER=$(hostname | sed 's/ubuntu-vm-//')

# Get the path to the OpenVPN configuration file.
# The OpenVPN configuration file is injected into the initrd by the
# `provision_vms.sh` script and is available in the root directory.
OVPN_FILE=$(find / -name "*.ovpn" -print -quit)

# Run the configuration script, passing the VM number and the path to the
# OpenVPN configuration file as arguments.
/root/configure_vm.sh $VM_NUMBER "$OVPN_FILE"
