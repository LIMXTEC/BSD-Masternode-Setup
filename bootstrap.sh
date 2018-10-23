#!/bin/bash
COIN_CHAIN_FILE='bitsend-blockchain.tar.gz'
COIN_CHAIN='https://node-support.network/bootstrap/'$COIN_CHAIN_FILE
COIN_NAME='BitSend'
COIN_PATH='/root/.bitsend'
TMP_PATH='/root/bootstrap_temp'

mkdir $TMP_PATH
cd $TMP_PATH
echo -e "Downloading and extracting $COIN_NAME blockchain files."
wget -q $COIN_CHAIN
tar -xzvf $COIN_CHAIN_FILE -C $TMP_PATH/
rm -rf $COIN_PATH/blocks/
rm -rf $COIN_PATH/chainstate/
mv $TMP_PATH/root/Bootstrap/.bitsend/blocks/ $COIN_PATH/
mv $TMP_PATH/root/Bootstrap/.bitsend/chainstate/ $COIN_PATH/
cd ~
rm -r $TMP_PATH
