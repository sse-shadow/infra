### Purpose

Place to keep scrips and generator configs incase anything needs reconfigured.

Setting up Vault
----------------

This is by far the simplist of the two. Grab yourself an up to date Centos7 box and run through the following

```sh
# install unit files from local 
scp ./unit_files/*.service root@vault.ssealumni.tech:/usr/lib/systemd/system/
scp ./vault/ root@vault.ssealumni.tech:/root/

ssh root@vault.ssealumni.tech

# Install caddy 
curl https://getcaddy.com | bash -s personal

# Run caddy once and accept terms and input email
caddy

# Start all services
systemctl enable caddy-proxy
systemctl start caddy-proxy

systemctl enable vault-server
systemctl start vault-server
```

vault will run listening only to localhost. And is configured to store data encrypted in the home folder (TODO: confider other options like consul but its not that important, at lease we should put it in a volume). Caddy will proxy will letsencrypt certs and handle renewing them for us.

Setting up Postgres-10
----------------------

Because we used 10, and this machine has a volume mount for the DB, configuration has a few more steps. Once again, grab yourself an up to date Centos7 machine.

### Getting certs

```sh
scp ./move_certs.sh root@ssedb.ssealumni.tech:/root/

ssh root@ssedb.ssealumni.tech

yum install epel-release
yum install certbot

certbot certonly  # follow prompts

crontab -e

0 0 1 * * /usr/bin/certbot renew --post-hook /root/move_certs.sh
```

Using certbots —post-hook we move the certs into the DB volume and change the permissions to make postgres happy.

### Installing Postgres

Install and initdb

```sh
rpm -Uvh https://yum.postgresql.org/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm

yum install postgresql10-server postgresql10

chown -R postgres:postgres /mnt/volume-sfo2-01

systemctl edit postgresql-10.service
# add
# [Service]
# Environment=PGDATA=/mnt/volume-sfo2-01/data

systemctl daemon-reload

/usr/pgsql-10/bin/postgresql-10-setup initdb
```

Configure to use ssl

```sh
# From local machine
scp ./postgres.prod.conf root@ssedb.ssealumni.tech:/mnt/volume-sfo2-01/data/postgresql.conf

vim /mnt/volume-sfo2-01/data/pg_hba.conf
# Allow remote password auth
host    all             all             0.0.0.0/0               md5

./move_certs.sh
```

Start postgres and set a root password

```sh
systemctl enable postgresql-10
systemctl start postgresql-10

su postgres
psql
\password postgres
<root password>
```

