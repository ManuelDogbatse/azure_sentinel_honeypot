# Setting up the Honeypot

### Table of Contents

[Initial Virtual Machine Setup](#initial-virtual-machine-setup)

[Sections](#sections)

## Initial Virtual Machine Setup

Now that the virtual machine, the log analytics workspace, and the Microsoft Sentinel instance are setup up, the next step is setting up the virtual machine from the inside. There are three things that need to be done: changing the real SSH port, installing Docker to run the honeypot, and configuring iptables to hide the real SSH server from port scanning.

Firstly, go to Azure and in the top search bar, search 'virtual machine' and select the 'Virtual machines' option. Then select 'vm-honeypot' and copy the virtual machine's public IP address.

<p align="center">
<img src="../../images/pub_ip_addr.png" alt="Virtual machine's public IP address" height=55px>
</p>

Then go to either your terminal or an SSH client such as PuTTY or Mobaxterm, and then connect to port 22 of your VM via SSH using the username you entered during the creation of the VM, and the private key you created in the terminal.

```bash
ssh -i <private_key> <username>@<ip_address>
```

In the terminal, download the zip file that contains the server setup scripts from this GitHub repository:

```bash
wget 
```

Then unzip the zip file:

```bash
sudo apt install unzip
unzip server_setup.zip
```


## Sections

#### Home Page: [Azure Sentinel Honeypot](../../)

#### Previous Section: [Setting up Azure Resources](../azure_setup/)

#### Next Section: [...](...)
