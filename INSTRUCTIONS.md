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
3.  Make the script executable:

    ```bash
    chmod +x provision_vms.sh
    ```

4.  Run the script:

    ```bash
    ./provision_vms.sh
    ```

    This will start the process of creating the 10 virtual machines. You can monitor the progress using the `virsh list --all` command.

## 4. Configure the Virtual Machines

Once the virtual machines have been created, you need to configure each one individually.

1.  Open Virtual Machine Manager (`virt-manager`).
2.  For each VM, open the console and complete the Ubuntu installation.
3.  Once the installation is complete, open a terminal in the VM and run the following commands to make the `configure_vm.sh` script executable:

    ```bash
    chmod +x configure_vm.sh
    ```

4.  Run the script:

    ```bash
    ./configure_vm.sh
    ```

    This will install Telegram, OpenVPN, and a VNC server on the VM.

5.  You will be prompted to set a password for the VNC server.

6.  You will need to manually configure OpenVPN with your `.ovpn` file.

7.  You can now connect to the VM using a VNC client. The VNC server will be running on port 5900.

Repeat these steps for each of the 10 virtual machines.
