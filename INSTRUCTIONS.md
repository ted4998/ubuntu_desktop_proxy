# Instructions for Setting Up Your Virtual Machines

## 1. Enable Nested Virtualization

Before you begin, you need to enable nested virtualization on your ESXi host. This will allow your Ubuntu VM to run its own nested virtual machines.

1.  **Enable Promiscuous Mode:**
    *   Log in to your ESXi host's web interface.
    *   Navigate to **Networking > Virtual Switches**.
    *   Select the virtual switch that your Ubuntu VM is connected to.
    *   Click **Edit settings**.
    *   Go to the **Security** tab.
    *   Set **Promiscuous mode** to **Accept**.
    *   Click **Save**.

2.  **Enable Nested Virtualization for the VM:**
    *   Shut down your Ubuntu VM.
    *   Right-click the VM in the vSphere Client and select **Edit Settings**.
    *   Go to the **CPU** section.
    *   Check the box for **Expose hardware assisted virtualization to the guest OS**.
    *   Click **OK**.

## 2. Install KVM and Dependencies

1.  Start your Ubuntu VM.
2.  Open a terminal and run the following command to make the `install_kvm.sh` script executable:

    ```bash
    chmod +x install_kvm.sh
    ```

3.  Run the script:

    ```bash
    ./install_kvm.sh
    ```

4.  Log out and log back in for the group changes to take effect.

## 3. Provision the Virtual Machines

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

## 4. Complete the Ubuntu Installation

1.  Open Virtual Machine Manager (`virt-manager`).
2.  For each VM, open the console and complete the Ubuntu installation.

## 5. Connect to the Virtual Machines

Once the Ubuntu installation is complete, the `configure_vm.sh` script will automatically run on the first boot. This will install Telegram, OpenVPN, and a VNC server on the VM.

You can connect to each VM using a VNC client. The VNC port for each VM will be `5900 + VM_NUMBER`. For example, `ubuntu-vm-1` will be accessible on port `5901`, `ubuntu-vm-2` will be accessible on port `5902`, and so on.

The OpenVPN connection will also be automatically established. You can verify the connection by running the `ifconfig` command in the VM and checking for a `tun0` interface.
