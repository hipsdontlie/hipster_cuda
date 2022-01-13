# Hipster Development Environment Setup 

The following steps will walk you through the complete development environment setup using Docker and ROS. 

## Installing Git

Git is a version control system that collaborative projects use. 

1. Install Git

```bash
sudo apt-get update
sudo apt-get install git
```

2. Testing 

```bash
git --version
```

If you see a version number like shown below, Git has been successfully installed. 

```bash
git version 2.24.0
```

## Editing Markdown Files

Markdown files (with the extension .md) are often found alongside any Git repository. It is the place where teams document details and setup instructions, such as the one you're viewing right now. However, making .md files look pretty and readable can be harder than it seems. A tool I've used in the past which I find quite useful is called 'Typora', and it can be installed as follows: 

```bash
#add keys
wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -

# add Typora's repository
sudo add-apt-repository 'deb https://typora.io/linux ./'
sudo apt-get update

# install typora
sudo apt-get install typora
```

There are many useful features with this editor, such as adding the appropriate headings, adding code blocks, inserting tables, adding in-line math symbols and blocks using $Latex$ features, check boxes for To-do lists etc. For a quick overview of these capabilities, [here](https://youtu.be/yigIbd54CU4) is a quick video.  

## Terminal 

When working with ROS, we usually need to have multiple terminals open at the same time, and keep switching between having them open and closed. It can get messy with the default terminal installation that comes with Ubuntu. Here are two options which have worked for me: 

1. Guake Drop-down terminal

```bash
# add PPA
sudo add-apt-repository ppa:linuxuprising/guake

#installation
sudo apt update
sudo apt install guake
```

2. Terminator

```bash
# add PPA
sudo add-apt-repository ppa:mattrose/terminator

#installation
sudo apt-get update
sudo apt-get install terminator
```

## Installing Docker 

The motivation behind using Docker is that all developers can remain on a uniform development environment. Assuming that you are using Ubuntu, you can install Docker using the recommended steps below. For any other OS, follow the official instructions here. 

1. Uninstall old versions (if any)

```bash
sudo apt-get remove docker docker-engine docker.io containerd runc
```

2. Installation 

```bash
sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get install docker-ce docker-ce-cli containerd.io
```

3. Test if docker is installed correctly by running the ``` hello-world ``` image:

```bash
sudo docker run hello-world
```

4. To avoid having to run sudo all the time, add your user to the `docker` group, and restart your system for this this to take effect:

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker 

#restart your system and now run docker without sudo 
docker run hello-world
```

5. If you initially ran Docker CLI commands using `sudo` before adding your user to the `docker` group, you may see the following error, which indicates that your `~/.docker/` directory was created with incorrect permissions due to the `sudo` commands.

   ```none
   WARNING: Error loading config file: /home/user/.docker/config.json -
   stat /home/user/.docker/config.json: permission denied
   ```

   To fix this problem, either remove the `~/.docker/` directory (it is recreated automatically, but any custom settings are lost), or change its ownership and permissions using the following commands:

   ```bash
    sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
    sudo chmod g+rwx "$HOME/.docker" -R
   ```

## CUDA + Docker

1. Verify the installation with the command `nvidia-smi`. You will see following output:

```
    +-----------------------------------------------------------------------------+
    | NVIDIA-SMI 390.116                Driver Version: 390.116                   |
    |-------------------------------+----------------------+----------------------+
    | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
    | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
    |===============================+======================+======================|
    |   0  GeForce GTX 560 Ti  Off  | 00000000:01:00.0 N/A |                  N/A |
    | 40%   46C    P8    N/A /  N/A |    790MiB /  1217MiB |     N/A      Default |
    +-------------------------------+----------------------+----------------------+

    +-----------------------------------------------------------------------------+
    | Processes:                                                       GPU Memory |
    |  GPU       PID   Type   Process name                             Usage      |
    |=============================================================================|
    |    0                    Not Supported                                       |
    +-----------------------------------------------------------------------------+
```

If NVIDIA driver is not pre-installed with your Ubuntu distribution, you can install it with `sudo apt install nvidia-XXX` (XXX is the version, the newest one is 440) or download the appropriate [NVIDIA driver](https://www.nvidia.com/en-us/drivers/unix/linux-amd64-display-archive/) and execute the binary as sudo.

2. Install NVIDIA container runtime:

```bash
curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list |\
    sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list
sudo apt-get update
sudo apt-get install nvidia-container-runtime
```

3. Restart Docker 

```bash
sudo systemctl stop docker
sudo systemctl start docker
```

4. Run CUDA in docker. This will pull the CUDA image and run it on docker. 

```bash
docker run --gpus all nvidia/cuda:10.1-cudnn7-devel nvidia-smi
```

5. If you get the same output as above after running step 4, you're done!

6. Install Nvidia-docker-2 for hardware acceleration:

```
sudo apt-get install -y nvidia-docker2
```

7. Restart daemon and docker 

```
sudo systemctl daemon-reload
sudo systemctl restart docker
```

## Configure Docker to start on boot

Most current Linux distributions use [`systemd`](https://docs.docker.com/config/daemon/systemd/) to manage which services start when the system boots. On Debian and Ubuntu, the Docker service is configured to start on boot by default. To automatically start Docker and Containerd on boot for other distros, use the commands below:

```bash
 sudo systemctl enable docker.service
 sudo systemctl enable containerd.service
```

## Allow Xhost to Allow GUI Applications from Docker

Run this to allow xhost-server run GUI applications from any client: 

```bash
xhost +
```

## Pullling the Docker Environment

1. Start by cloning the setup_repository from the repository to your home directory:

```bash
cd ~/
git clone https://github.com/hipsdontlie/hipster_cuda.git
```

2. Pull the docker image from DockerHub

```bash
docker pull kaushikbalasundar/manipulation_env_cuda_10_1:cuda
```

3. Add the following alias to your ~/.bashrc

```bash
echo 'alias hip="cd ~/hipster_cuda && ./run_my_image.bash"' >> ~/.bashrc
source ~/.bashrc
```

4. You can now start your docker environment by opening a new terminal by typing:

```bash
hip
```



## You're Done!