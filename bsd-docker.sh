#!/bin/bash
set -u

GIT_REPO="LIMXTEC"
GIT_PROJECT="BSD-Masternode-Setup"
DOCKER_REPO="limxtec" #only lowercase
IMAGE_NAME="bsd-masternode"
IMAGE_TAG="0.14.2.0" #BSD Version 0.14.2.0
CONFIG="/home/bitsend/.bitsend/bitsend.conf"
CONTAINER_NAME="bsd-masternode"
DEFAULT_PORT="8886"
RPC_PORT="8800"
TOR_PORT="9051"
WEB="www.mybitsend.com" # without "https://" and without the last "/" (only HTTPS accepted)
BOOTSTRAP="bootstrap.tar.gz"
IP=$(curl -s https://bit-cloud.info/showip.php)

#
# Color definitions
#
RED='\033[0;31m'
GREEN='\033[0;32m'
NO_COL='\033[0m'
BSD_COL='\033[0;34m'

#
# Check if bitsend.conf already exist. Set masternode genkey.
#
clear
REUSE="No"
printf "\nDOCKER SETUP FOR ${BSD_COL}BITSEND (BSD) V${IMAGE_TAG}${NO_COL} RPC SERVER\n"
printf "\nSetup Config file"
printf "\n-----------------\n"
if [ -f "$CONFIG" ]
then
    printf "\nFound $CONFIG on your system.\n"
    printf "\nDo you want to re-use this existing config file?\n" 
    printf "Enter [Y]es or [N]o and Hit [ENTER]: "
    read REUSE
fi

if [[ $REUSE =~ "N" ]] || [[ $REUSE =~ "n" ]]; then
    read -e -p "Is this IP-address $IP your VPS IP-address? [Y/n]: " ipaddress
    if [[ ("$ipaddress" == "n" || "$ipaddress" == "N") ]]; then
        printf "\nEnter the IP-address of your ${BSD_COL}BitSend${NO_COL} Masternode VPS and Hit [ENTER]: "
        read BSD_IP
    else
        BSD_IP=$(echo $IP)
    fi
    printf "Enter your ${BSD_COL}BitSend${NO_COL} Masternode genkey respond and Hit [ENTER]: "
    read MN_KEY
else
    source $CONFIG
    BSD_IP=$(echo $externalip)
    MN_KEY=$(echo $masternodeprivkey)
fi


#
# Docker Installation
#
if ! type "docker" > /dev/null; then
    curl -fsSL https://get.docker.com | sh
fi

#
# Firewall Setup
#
printf "\nDownload needed Helper-Scripts"
printf "\n------------------------------\n"
wget https://raw.githubusercontent.com/${GIT_REPO}/${GIT_PROJECT}/master/check_os.sh -O check_os.sh
chmod +x ./check_os.sh
source ./check_os.sh
rm ./check_os.sh
wget https://raw.githubusercontent.com/${GIT_REPO}/${GIT_PROJECT}/master/firewall_config.sh -O firewall_config.sh
chmod +x ./firewall_config.sh
source ./firewall_config.sh ${DEFAULT_PORT} ${RPC_PORT} ${TOR_PORT}
rm ./firewall_config.sh


#
# Pull docker images and run the docker container
#
printf "\nStart Docker container"
printf "\n----------------------\n"
sudo docker ps | grep ${CONTAINER_NAME} >/dev/null
if [ $? -eq 0 ];then
    printf "${RED}Conflict! The container name \'${CONTAINER_NAME}\' is already in use.${NO_COL}\n"
    printf "\nDo you want to stop the running container to start the new one?\n"
    printf "Enter [Y]es or [N]o and Hit [ENTER]: "
    read STOP

    if [[ $STOP =~ "Y" ]] || [[ $STOP =~ "y" ]]; then
        docker stop ${CONTAINER_NAME}
    else
	printf "\nDocker Setup Result"
        printf "\n----------------------\n"
        printf "${RED}Canceled the Docker Setup without starting ${BSD_COL}BitSend${RED} Masternode Docker Container.${NO_COL}\n\n"
	exit 1
    fi
fi
docker rm ${CONTAINER_NAME} >/dev/null
docker pull ${DOCKER_REPO}/bsd-masternode
docker run --rm \
 -p ${DEFAULT_PORT}:${DEFAULT_PORT} \
 -p ${RPC_PORT}:${RPC_PORT} \
 -p ${TOR_PORT}:${TOR_PORT} \
 --name ${CONTAINER_NAME} \
 -e BSD_IP="${BSD_IP}" \
 -e MN_KEY="${MN_KEY}" \
 -e WEB="${WEB}" \
 -e BOOTSTRAP="${BOOTSTRAP}" \
 -v /home/bitsend:/home/bitsend:rw \
 -d ${DOCKER_REPO}/${IMAGE_NAME}:${IMAGE_TAG}


#
# Show result and give user instructions
#
clear
printf "\nDocker Setup Result"
printf "\n----------------------\n"
sudo docker ps | grep ${CONTAINER_NAME} >/dev/null
if [ $? -ne 0 ];then
    printf "${RED}Sorry! Something went wrong. :(${NO_COL}\n"
else
    printf "${GREEN}GREAT! Your ${BSD_COL}BitSend (v${IMAGE_TAG})${GREEN} Masternode Docker Container is running now! :)${NO_COL}\n"
    printf "\nShow your running docker container \'${CONTAINER_NAME}\' with 'docker ps'\n"
    sudo docker ps | grep ${CONTAINER_NAME}
    printf "\nJump inside the ${BSD_COL}BitSend (BSD)${NO_COL} Masternode Docker Container with ${GREEN}'docker exec -it ${CONTAINER_NAME} bash'${NO_COL}\n"
    printf "\nCheck Log Output of ${BSD_COL}BitSend (BSD)${NO_COL} Masternode with ${GREEN}'docker logs ${CONTAINER_NAME}'${NO_COL}\n"
    printf "${GREEN}HAVE FUN!${NO_COL}\n\n"
fi
