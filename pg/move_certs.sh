#!/bin/bash

cp /etc/letsencrypt/live/ssedb.ssealumni.tech/cert.pem /mnt/volume-sfo2-01/
cp /etc/letsencrypt/live/ssedb.ssealumni.tech/privkey.pem /mnt/volume-sfo2-01/

chown -R postgres:postgres /mnt/volume-sfo2-01/
chmod 600 /mnt/volume-sfo2-01/cert.pem
chmod 600 /mnt/volume-sfo2-01/privkey.pem

systemctl restart postgresql-10