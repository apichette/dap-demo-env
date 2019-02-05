#!/bin/bash -x
# Minishift v1.23 is the latest version that still support Openshift 3.9
MINISHIFT_VERSION=1.23.0
VBOX_VERSION=5.2

xxmain() {
  install_jq
  install_vbox
  install_docker
  install_docker_compose
  install_minikube
  install_weavescope
}

main() {
  install_minishift
}

install_jq() {
  sudo wget -O /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && chmod +x /usr/local/bin/jq
}

install_vbox() {
  printf "\nInstalling kernel extensions..."
  sudo yum install -y kernel-devel kernel-headers make patch gcc
  printf "\nUpdate repos w/vbox repo..."
  sudo wget https://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo -P /etc/yum.repos.d
  printf "\nInstalling VirtualBox $VBOX_VERSION..."
  sudo yum install -y VirtualBox-$VBOX_VERSION
}

install_docker() {
  printf "\nInstalling docker..."
  sudo yum install -y yum-utils device-mapper-persistent-data lvm2
  sudo yum-config-manager --add-repo \
		https://download.docker.com/linux/centos/docker-ce.repo
  sudo yum install -y docker-ce
  sudo systemctl start docker
  sudo usermod -aG docker $USER
}

install_docker_compose() {
  printf "\nInstalling docker-compose..."
  sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
}

install_minishift() {
  printf "\nInstalling minishift v${MINISHIFT_VERSION}..."
  wget https://github.com/minishift/minishift/releases/download/v$MINISHIFT_VERSION/minishift-$MINISHIFT_VERSION-linux-amd64.tgz
  tar xvzf minishift-$MINISHIFT_VERSION-linux-amd64.tgz */minishift > ./minishift
  chmod +x minishift
  sudo mv minishift /usr/local/bin
  rm minishift-$MINISHIFT_VERSION-linux-amd64.tgz
}

install_minikube() {
  curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  chmod +x minikube
  sudo mv minikube /usr/local/bin
  curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v1.13.2/bin/linux/amd64/kubectl 
  chmod +x kubectl 
  sudo mv kubectl /usr/local/bin/
}

install_weavescope() {
  sudo curl -L git.io/scope -o /usr/local/bin/scope
  sudo chmod a+x /usr/local/bin/scope
}

main "$@"
