#!/bin/bash -x

main() {
  install_vbox
  install_minishift
  install_docker_compose
}

install_vbox() {
  printf "\nInstalling kernel extensions..."
  sudo yum install kernel-devel kernel-headers make patch gcc
  printf "\nUpdate repos w/vbox repo..."
  sudo wget https://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo -P /etc/yum.repos.d
  printf "\nInstalling VirtualBox 5.2..."
  sudo yum install VirtualBox-5.2
}

install_minishift() {
  printf "\nDownloading minishift executable..."
  wget https://github.com/minishift/minishift/releases/download/v1.30.0/minishift-1.30.0-linux-amd64.tgz
  tar xvzf minishift-1.30.0-linux-amd64.tgz */minishift -O > ./minishift
  chmod +x minishift
  sudo mv minishift /usr/local/bin
}

install_docker_compose() {
  sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
}

main "$@"
