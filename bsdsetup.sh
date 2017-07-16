
#!/bin/bash
# This script will install all needed stuff to run a BitSend (BSD) Masternode.
# BitSend Repo : https://github.com/LIMXTEC/BitSend
# !! THIS SCRIPT NEED TO RUN AS ROOT !!
######################################################################

clear
echo "*********** Welcome to the BitSend (BSD) Masternode Setup Script ***********"
echo 'This script will install all required updates & package for Ubuntu 14.04 !'
echo 'Clone & Compile the BSD Wallet also help you on first setup and sync'
echo '****************************************************************************'
sleep 3
echo '*** Step 1/5 ***'
echo 'Creating 2GB Swapfile'
sleep 1
dd if=/dev/zero of=/mnt/mybsdswap.swap bs=2M count=1000
mkswap /mnt/mybsdswap.swap
swapon /mnt/mybsdswap.swap
sleep 1
echo '*** Done 1/5 ***'
sleep 1
echo '*** Step 2/5 ***'
echo 'Running updates and install required packages'
sleep 2