#!/bin/bash

echo -e "\033[1m Enter Your Tenant Name: \033[0m" 
read tenant

echo -e "\033[1m Enter Your Project Name: \033[0m" 
read project

echo -e "\033[1m Enter 'LEARNING' or 'ENFORCE': \033[0m" 
read mode

echo -e "\033[1m Enter your Username: \033[0m"
read username

echo -e "\033[1m Enter your Password: \033[0m"
read -s password

TENANT=$(echo $tenant)
USERNAME=$(echo $username)
PASSWORD=$(echo $password)
PROJECT=$(echo $project)

echo -e "\033[1m Here are your details:  \033[0m"
echo
echo " Tenant = $TENANT"
echo " Username = $USERNAME"

curl -s --location --request POST https://securecloud.tufin.io/auth/realms/$TENANT/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode "username=$USERNAME" --data-urlencode "password=$PASSWORD" --data-urlencode 'client_id=express' --data-urlencode 'grant_type=password' | jq .access_token > ~/tmp/temptoken.txt

sed 's/\"//g' ~/tmp/temptoken.txt > ~/tmp/temptoken2.txt

ACCESS_TOKEN="$(cat ~/tmp/temptoken2.txt)"

curl -X 'POST'  -H "Authorization: Bearer $ACCESS_TOKEN" \
"https://$TENANT.securecloud.tufin.io/api/v1/orca/conf/clusters/$PROJECT/rules-from-connections" \
  -H 'accept: */*' \
  -d ''