#!/bin/bash
set -u

#
# Set passwd of bitsend user
#
echo bitsend:${BSDPWD} | chpasswd

#
# Downloading bitsend.conf
#
cd /tmp/
wget https://raw.githubusercontent.com/dalijolijo/BSD-Masternode-Setup/master/bitsend.conf -O /tmp/bitsend.conf
chown bitsend:bitsend /tmp/bitsend.conf

#
# Set rpcuser, rpcpassword and masternode genkey
#
printf "** Set rpcuser, rpcpassword and masternode genkey ***\n"
mkdir -p /home/bitsend/.bitsend
chown -R bitsend:bitsend /home/bitsend
sudo -u bitsend cp /tmp/bitsend.conf /home/bitsend/.bitsend/
sed -i "s/^\(rpcuser=\).*/rpcuser=bsdmasternode${BSDPWD}/" /home/bitsend/.bitsend/bitsend.conf
sed -i "s/^\(rpcpassword=\).*/rpcpassword=${BSDPWD}/" /home/bitsend/.bitsend/bitsend.conf
sed -i "s/^\(masternodeprivkey=\).*/masternodeprivkey=${MN_KEY}/" /home/bitsend/.bitsend/bitsend.conf

#
# Downloading bootstrap file
#
printf "** Downloading bootstrap file ***\n"
cd /home/bitsend/.bitsend/
if [ ! -d /home/bitsend/.bitsend/blocks ] && [ "$(curl -Is https://${WEB}/${BOOTSTRAP} | head -n 1 | tr -d '\r\n')" = "HTTP/1.1 200 OK" ] ; then \
        sudo -u bitsend wget https://${WEB}/${BOOTSTRAP}; \
        sudo -u bitsend tar -xvzf ${BOOTSTRAP}; \
        sudo -u bitsend rm ${BOOTSTRAP}; \
fi

#
# Step Starting BitSend Service
#
# Hint: docker not supported systemd, use of supervisord
printf "*** Starting BitSend Service ***\n"
exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
