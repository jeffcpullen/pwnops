#!/bin/bash

while [[ true ]]
do
  HASH=$(date +%h%d%H%y | md5sum | awk '{ print $1 }')
  SERVER_NAME=$( echo $HASH | head -c 16)
  DOMAIN_NAME=$( echo $HASH | tail -c 17 | head -c 16)
  curl $SERVER_NAME.$DOMAIN_NAME.com 2>/dev/null
  sleep $((RANDOM%300))
done
