#!/bin/bash
# Script installs tools, utilities & software needed for development

for i in "$@"; do
    case $i in
    -c=* | --conda=*)
        CONDA="${i#*=}"
        shift
        ;;
    -d=* | --docker=*)
        DOCKER="${i#*=}"
        shift
        ;;
    -n=* | --nvidia=*)
        NVIDIA="${i#*=}"
        shift
        ;;
    -h)
        HELP=true
        shift
        ;;
    *) ;;

    esac

done

if $HELP; then
    echo "This is the master script for setting up a dev environment in a fresh install for Ubuntu."
    echo "The script installs VSCode, basic build tools and utilities by default and a few other things if specified by the user"
    echo -e "-c | --conda\nif set to true install miniconda3 in the home directory\n"
    echo -e "-d | --docker\nif set to true installs docker container runtime along with docker-compose\n"
    echo -e "-n | --nvidia\nif set to true installs recommended nvidia-drivers for the system, along with nvidia-cuda tools and nvidia-docker setup"
    exit 0
else
    sudo apt install build-essential net-tools # install gcc, make, etc

    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    rm -f packages.microsoft.gpg
    sudo apt install apt-transport-https
    sudo apt update
    sudo apt install code # install vscode

    sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 0
    pip install -U pip # create alias for python3->python
    if $CONDA; then
        echo "Installing miniconda3 ... "
        bash conda_setup.sh
        echo "Miniconda3 install completed!"
    fi

    if $DOCKER; then
        echo "Installing docker ... "
        bash docker_setup.sh
        echo "Docker install completed!"
    fi

    if $NVIDIA; then
        echo "Installing nvidia libraries and drivers ... "
        bash nvidia_setup.sh
        echo "Nvidia install completed!"
    fi
fi
