#!/bin/bash

#Pulls Hostname and echo's
echo "FQDN: $HOSTNAME"

hostnamectl status

cat /etc/*-release
