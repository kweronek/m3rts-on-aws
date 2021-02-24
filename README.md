# Getting started on EC2

## Introduction

Elastic Compute Cloud (EC2) is a commercial service for hosting virtual machines, called instances, under the Amazon Web Services (AWS) label. This tutorial will get you started with an Ubuntu system on EC2 using AWS Educate.
You should have received an invitation E-Mail for the service already. Click on the enclosed link and follow the instructions to create an account. In case the link does not work, in particular if your browser shows a TLS error, try the original link from the E-Mail in a different browser (this happened during testing). Please note that AWS considers this an application and approval can take a while. In my case it was about 15 minutes.

To access EC2, log into [AWS Educate](https://www.awseducate.com/), click on my classrooms and go to the Software Oriented Architecture classroom. This will take you to a third party site called Vocareum that gives you access to the AWS Console. Some popup blockers break this, so you may need to whitelist Vocareum there. On the AWS Console go to all services and click on EC2. Do not attempt to change the data center location. Selecting anything but the default (us-east-1/North Virginia) will appear to work at first but is not supported by AWS Educate and will lead to nothing but unclear error messages later.

You should now:
- Find your invitation E-Mail
- Create an AWS Educate account
- Proceed with the local part of the OpenSSH section while waiting for confirmation
- Log in to [AWS Educate](https://www.awseducate.com/signin/SiteLogin)
- Go to `My Classrooms`
- On the SOA course, select `Go to Classroom` and click continue
- Click on `ÀWS Console`
- Under `Services` go to `EC2` to reach the EC2 dashboard


## OpenSSH

While your "application" is processing you can do some preparations for connecting to virtual machine instances.
To access your virtual machine we are going to use the [OpenSSH](https://www.openssh.com/) client. Other implementations should work as well but have not been tested by us and won't be covered here.

Depending on your operating system you may need to install the software. On Linux and BSD based systems it is usually available via a package manager. The corresponding package is typically called `openssh` or `openssh-client`.
On recent versions of Windows (Windows 10 build 1809 and up) an OpenSSH port is available as an optional operating system feature. To install it, start `Settings` then go to `Apps > Apps and Features > Manage Optional Features`. Client and Server are separated.

First create a ssh key pair compatible with EC2. EC2 requires the use of RSA keys of specific lengths. RSA keys longer then 4096 bits and other key types like Ed25519 unfortunately won't work at this time. If you already have a compatible key you can use that one for EC2 as well.
To generate such a key you can use the command `ssh-keygen -t rsa -b 4096`.
You can adjust the filename using `-f /path/to/file` but deviating from the default will require you to specify its location later.
This will create a text file called `id_rsa.pub` that contains the public key and an encrypted file called `id_rsa` that contains the private (as well as the public) key inside of the `.ssh` subdirectory of your home directory.

To use your key for EC2 you will need to upload it there first. On the EC2 dashboard go to `Network and Security > Key Pairs` and select `Actions > Import key pair`. You can either upload your keys `.pub` file or paste its contents in the text field.

You should now:
- Install the OpenSSH client on your local system
- Open a terminal/command prompt window
- Create a key pair by running `ssh-keygen -t rsa -b 4096`
- Find your key pairs `.pub` file
- Log into AWS Educate and go to the EC2 dashboard
- Go to  `Network and Security > Key Pairs`
- Import your public key by clicking on `Actions > Import key pair`


## EC2 Instances

Now that you have a public key uploaded you can create a new EC2 instance. In the EC2 Dashboard go to `Instances` and select `Start Instances`. You are presented a list of Amazon Machine Images (AMIs) that contain different base systems. For this course the only supported base image is `Ubuntu Server 20.04 LTS` for 64-bit x86 processors. After selecting it you will be presented a (long) list of hardware configurations. For command line only access a t2.micro can be used but won't be able to handle any significant load or graphical user interfaces. For these loads usage of a c5.large is recommended. In the following steps you can configure further settings. For the purpose of this course the default settings are fine. For your own sanity you should name your instance by adding a tag with the key `Name`, so that you can tell your instances apart later. When launching your instance you will be prompted to select an ssh key. You should pick the key you previously uploaded here.

As your budget is limited for each classroom you should always shut down your virtual machines when you don't use them. You can either do that by logging into the vm and shutting it down from the inside or stop it from the instances view of the dashboard (select instance, click on action, move over status, click on stop instance). In the latter there is a very unfortunate naming issue. `Stop Instance`/`Instanz stoppen` shuts down a VM, while `Terminate Instance`/`Instanz beenden` permanently deletes an instance with all files on it. A terminated instance will be rendered unusable immediately and completely removed after a few hours.

Another important point is that EC2 instances are run behind a firewall. It's configuration is called a security group and is editable from the security tab of the instance details page. The default setup allows port 22 (SSH) to be accessed by any IP and drops any other traffic. If you want to run a service you either need to make the relevant port(s) accessible there or access them from the instance itself. How to do this will be explained later.

You should now:
- Log into AWS Educate and go to the EC2 dashboard
- Go to the instance videw and select `Start Instance/Instanz starten` in the top right
- Select the 64-bit x86 build of `Ubuntu Server 20.04 LTS`
- Select the instance type `c5.large`
- Proceed to step 5 and select `click to add a Name tag` to name your instances
- Launch the instance and select the public key you uploaded earlier in the prompt
- You will be directed to a page called `Launch Status` telling you that your instance is launching. Click on the instance ID to show the instance in the instance view of the EC2 dashboard. Click on the ID again to go to the instance details
- Make yourself familiar with the `Instance Status` menu in the top right. You can stop (not terminate) and restart your instance for testing if you want
- Obtain the instances public IP address or DNS entry from the top middle of the view
- Click on the security tab to find the security group (firewall) configuration
- Proceed with the next section


## Connecting to your instance

### Connecting to your instance using OpenSSH

To connect to your VM you must first obtain its public IP address or public DNS name from the instance view on the EC2 dashboard.
You can then use the command `ssh ubuntu@<IP or DNS>`to connect to your virtual machine. Additional arguments can be supplied before the destination.
You will be prompted to accept the host keys from the remote host before the connection will be established. This is supposed to protect you from MITM-style attacks. Unfortunatly it is impossible to actually verify these without installing AWS software on your machine as described [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/connection-prereqs.html#connection-prereqs-fingerprint). Typing yes will add a new entry to your `known_hosts` file.
If you deviated from the default private key path earlier you can will need to specify it now by adding the argument `-i /path/to/private/key`.

You can also use ssh to forward network traffic to and from the remote host using an encrypted tunnel. This way you can access otherwise inaccessible ports, remote Unix file sockets and even traverse Source NATs on the clients end securely.
Local port forwarding is a feature where the ssh client opens a port or socket on the local machine and sends all traffic to it through the ssh tunnel. The ssh server then connects to the destination port or socket. This way you obtain a port on the client machine that somewhat matches the corresponding port on the server even if it is not directly reachable from the client. Since it is possible to have the server connect to different machines you need to specify three options per forwarded port: the local port to open as well as the destination machine and port. 
To create a local port forwarding add the option `-L <local port>:<destination machine>:<destination port>` to the ssh command.
Example: To forward traffic from the local port 80 to the port 8080 on the ssh target machine specify `-L80:localhost:8080`. 
Remote port forwarding does essentially the same thing in reverse. The ssh daemon opens a port on the host we are connecting to and forwards all traffic via our client. To create a remote port forwarding add the option `-R <remote port>:<destination machine>:<destination port>` to the ssh command.

Another useful utility is the scp (secure copy) program. It allows you to copy files between different machines using a ssh connection. It's usage is very similar to the ordinary cp with the addition of a way to specify the machine the path is on by prefixing it with `user@host:`. Uploading a local file to an Ubuntu based EC2 instance would look like this: `scp <ssh options> /path/to/local/file ubuntu@<IP or DNS>:/remote/destination/path`.

For more details about these features please consult the tools individual man pages.

You should now:
- Open a terminal/command prompt on your local system
- Obtain the instances public IP address or DNS name
- Run `ssh ubuntu@<IP or DNS>`
- Accept the remote fingerprint by typing yes
- Verify that you have obtained access to a shell on the remote system. You should see a somewhat lengthy "Welcome to Ubuntu" message.
- Proceed with the next section


### Setting up additional software
We have prepared scripts to install the software required for this course in this repository. To obtain a copy of them on the VM simply clone the repository using `git clone` and run the install script called `gui.sh` as root. This will install a desktop environment, a VNC and a RDP server and some configuration files. You may need to make the script(s) executable using `chmod +x` beforehand.

You should now:
- Connect to your VM using SSH
- Run `git clone https://github.com/kweronek/ubuntu-install.git`
- Change directory with `cd ubuntu-install`
- Run `chmod +x gui.sh`
- Run `sudo tmux new ./gui.sh`
- If you loose connection while the script is running reconnect and run `sudo tmux attach`
- Wait for the script to complete. It will take a while because it installs a lot of software
- Set up a graphical connection using either VNC or RDP


### Connecting to your instance using VNC
After setting your machine up, you can use VNC remotely access a desktop on your vm. You will need a VNC client like [TigerVNC](https://tigervnc.org/) or [Remmina](https://remmina.org/how-to-install-remmina/). VNC uses different ports for individual desktops starting with 5901 for the first non-physical display. Our instance is currently configured to run one desktop on port 5901 only. Since that port is not accessible by default you will need to either update your firewall configuration to accept TCP traffic on that port or use the local port forwarding feature of ssh to get past it.

To establish a VNC connection you will need to enter a VNC-specific password. The default password for this course will be communicated elsewhere. You can however change it at any time by using the vncpasswd utility over ssh.

You should now pick a method and connect to your machine:

Using a direct connection
- Install a VNC client (TigerVNC, Remmina etc.) on your local system.
- Open port 5901 in the security group of your instance
- Make sure your instance is up on the dashboard
- Optionally change your VNC password by running `vncpasswd` over ssh
- Open your VNC client and connect to <IP or DNS>:5901

Using SSH port forwarding
- Install a VNC client (TigerVNC, Remmina etc.) on your local system.
- Make sure your instance is up on the dashboard
- Connect using ssh with port forwarding to 5901:localhost:5901. If you get an error message saying that ssh connot listen to port 5901 change the local port
- Optionally change your VNC password by running `vncpasswd` over ssh
- Open your VNC client and connect to localhost:5901. If you had to change your local port, adjust it here as well


### Connecting to your instance using RDP
Alternatively you can use the Remote Desktop Protocol instead of VNC. Windows ships with a RDP client called mstsc.exe (Microsoft Terminal Services Client), however there is alternate implementations for various platforms like Remmina (FreeRDP) for Linux. The port used by RDP is 3389 and needs to be made accessible like for VNC. Once connected the RDP server will show a login screen where you can log in. For this you will first need to set a password for your `ubuntu` user using `sudo passwd ubuntu` over ssh.

You should now pick a method and connect to your machine:

Direct connection
- Install a VNC client (Remmina, FreeRDP etc.) on your local system or pick a preinstalled one
- Open port 5901 in the security group of your instance
- Connect to your instance using ssh and change the password of the user `ubuntu` by running `sudo passwd ubuntu`
- Open your VNC client and connect to <IP or DNS>:3389

Using SSH port forwarding
- Install a VNC client (Remmina, FreeRDP etc.) on your local system or pick a preinstalled one
- Make sure your instance is up on the dashboard
- Connect using ssh with port forwarding to 3390:localhost:3389. If you get an error message saying that ssh connot listen to port 3390 change the local port
- Change the password of the user `ubuntu` by running `sudo passwd ubuntu` over ssh
- Open your VNC client and connect to localhost:3390. If you had to change your local port, adjust it here as well


## Additional resources

[AWS EC2 - Connecting to your Linux instance using SSH](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html)

[OpenSSH overview by Microsoft](https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_overview)

[AWS EC2 - Connecting to your Linux instance from Windows using PuTTY](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/putty.html)

[SSH port forwarding on Linuxize](https://linuxize.com/post/how-to-setup-ssh-tunneling/)
