#!/bin/bash

# This script installs KVM and other necessary dependencies on an Ubuntu system.

# Update the package lists to ensure we have the latest information about available packages.
sudo apt-get update

# Install KVM, QEMU, and other virtualization-related packages.
# - qemu-kvm: The KVM hypervisor.
# - libvirt-daemon-system: The libvirt daemon, which manages virtual machines.
# - libvirt-clients: Client-side libraries and tools for managing virtual machines.
# - bridge-utils: Utilities for creating and managing network bridges.
# - virt-manager: A graphical user interface for managing virtual machines.
sudo apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager

# Add the current user to the `libvirt` and `kvm` groups.
# This is necessary to allow the user to manage virtual machines without using `sudo`.
sudo adduser $(whoami) libvirt
sudo adduser $(whoami) kvm

# Inform the user that they need to log out and log back in for the group changes to take effect.
echo "Please log out and log back in for the group changes to take effect."
