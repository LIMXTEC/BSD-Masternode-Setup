# BitSend (BSD) Masternode - Run Docker Image

## Adding firewall rules
Open needed ports on your docker host server.
```
ufw logging on
ufw allow 22/tcp
ufw limit 22/tcp
ufw allow 8886/tcp
ufw allow 8800/tcp
ufw allow 9051/tcp
ufw default deny incoming 
ufw default allow outgoing 
yes | ufw enable
```

## Pull docker image
```
docker pull limxtec/bsd-masternode
```

## Run docker container
```
docker run -p 8886:8886 -p 8800:8800 -p 9051:9051 --name bsd-masternode -e BSDPWD='NEW_BSD_PWD' -e MN_KEY='YOUR_MN_KEY' -e WEB="${WEB}" -e BOOTSTRAP="${BOOTSTRAP}" -v /home/bitsend:/home/bitsend:rw -d <repository>/bsd-masternode
docker ps
```

## Debbuging within a container (after start.sh execution)
Please execute ```docker run``` without option ```--entrypoint bash``` before you execute this commands:
```
tail -f /home/bitsend/.bitsend/debug.log

docker ps
docker exec -it bsd-masternode bash
  # you are inside the bsd-masternode container
  root@container# supervisorctl status bitsendd
  root@container# cat /var/log/supervisor/supervisord.log
  # Change to bitsend user
  root@container# sudo su bitsend
  bitsend@container# cat /home/bitsend/.bitsend/debug.log
  bitsend@container# bitsend-cli getinfo
```

## Debbuging within a container during run (skip start.sh execution)
```
docker run -p 8886:8886 -p 8800:8800 -p 9051:9051 --name bsd-masternode -e BSDPWD='NEW_BSD_PWD' -e MN_KEY='YOUR_MN_KEY' -e WEB="${WEB}" -e BOOTSTRAP="${BOOTSTRAP}" -v /home/bitsend:/home/bitsend:rw --entrypoint bash <repository>/bsd-masternode
```

## Stop docker container
```
docker stop bsd-masternode
docker rm bsd-masternode
```
