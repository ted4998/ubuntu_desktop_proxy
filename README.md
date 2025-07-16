# Multi-VM Setup

This repository contains a set of scripts for provisioning and configuring multiple Ubuntu virtual machines on a single host.

## Features

*   **Automated Provisioning:** Create 10 Ubuntu virtual machines with a single command.
*   **Unique Hardware IDs:** Each VM is assigned a unique MAC address to simulate a different hardware ID.
*   **Automated Configuration:** Each VM is automatically configured with:
    *   The latest updates
    *   Telegram
    *   OpenVPN
    *   A VNC server
*   **Custom VNC Ports:** Each VM is assigned a unique VNC port, starting from 5901.
*   **Automatic OpenVPN Connection:** Each VM automatically connects to an OpenVPN server on boot.

## How to Use

### 1. Prerequisites

*   An Ubuntu desktop machine (this can be a physical machine or a virtual machine running on a hypervisor such as ESXi).
*   If you are using a virtual machine, you must enable nested virtualization.

### 2. Enable Nested Virtualization (if applicable)

If you are running your Ubuntu desktop on a virtual machine, you must enable nested virtualization on the host hypervisor.

1.  **Enable Promiscuous Mode:**
    *   Log in to your hypervisor's web interface.
    *   Navigate to **Networking > Virtual Switches**.
    *   Select the virtual switch that your Ubuntu VM is connected to.
    *   Click **Edit settings**.
    *   Go to the **Security** tab.
    *   Set **Promiscuous mode** to **Accept**.
    *   Click **Save**.

2.  **Enable Nested Virtualization for the VM:**
    *   Shut down your Ubuntu VM.
    *   Right-click the VM in your hypervisor's client and select **Edit Settings**.
    *   Go to the **CPU** section.
    *   Check the box for **Expose hardware assisted virtualization to the guest OS**.
    *   Click **OK**.

### 3. Install KVM and Dependencies

1.  Start your Ubuntu desktop machine.
2.  Open a terminal and run the following command to make the `install_kvm.sh` script executable:

    ```bash
    chmod +x install_kvm.sh
    ```

3.  Run the script:

    ```bash
    ./install_kvm.sh
    ```

4.  Log out and log back in for the group changes to take effect.

### 4. Provision the Virtual Machines

1.  Download the Ubuntu 22.04 Desktop ISO image from the official website: [https://ubuntu.com/download/desktop](https://ubuntu.com/download/desktop)
2.  Open the `provision_vms.sh` script in a text editor and update the `ISO_PATH` variable to the path of the downloaded ISO file.
3.  Open the `configure_vm.sh` script in a text editor and update the `OVPN_FILE` variable to the path of your `.ovpn` file.
4.  Make the scripts executable:

    ```bash
    chmod +x provision_vms.sh
    chmod +x configure_vm.sh
    chmod +x firstboot.sh
    ```

5.  Run the provisioning script:

    ```bash
    ./provision_vms.sh
    ```

    This will start the process of creating the 10 virtual machines. You can monitor the progress using the `virsh list --all` command.

### 5. Complete the Ubuntu Installation

1.  Open Virtual Machine Manager (`virt-manager`).
2.  For each VM, open the console and complete the Ubuntu installation.

### 6. Connect to the Virtual Machines

Once the Ubuntu installation is complete, the `configure_vm.sh` script will automatically run on the first boot. This will install Telegram, OpenVPN, and a VNC server on the VM.

You can connect to each VM using a VNC client. The VNC port for each VM will be `5900 + VM_NUMBER`. For example, `ubuntu-vm-1` will be accessible on port `5901`, `ubuntu-vm-2` will be accessible on port `5902`, and so on.

The OpenVPN connection will also be automatically established. You can verify the connection by running the `ifconfig` command in the VM and checking for a `tun0` interface.

## To-Do List

*   [ ] Download the Ubuntu 22.04 Desktop ISO image.
*   [ ] Update the `ISO_PATH` variable in the `provision_vms.sh` script.
*   [ ] Update the `OVPN_FILE` variable in the `configure_vm.sh` script.
*   [ ] Run the `install_kvm.sh` script.
*   [ ] Run the `provision_vms.sh` script.
*   [ ] Complete the Ubuntu installation for each VM.
*   [ ] Connect to each VM using a VNC client.
*   [ ] Verify that the OpenVPN connection is established.
