#!/bin/bash

echo -e "\033[1m Enter Your Tenant Name: \033[0m" 
read tenant

echo -e "\033[1m Enter your Username: \033[0m"
read username

echo -e "\033[1m Enter your Password: \033[0m"
read -s password

echo -e "\033[1m Enter Your NEW Project Name: \033[0m"
read project_name





TENANT=$(echo $tenant)
USERNAME=$(echo $username)
PASSWORD=$(echo $password)
PROJECT_NAME=$(echo $project_name)


echo -e "\033[1m Here are your details:  \033[0m"
echo
echo " Tenant = $TENANT"
echo " Username = $USERNAME"
echo " New Project Name = $PROJECT_NAME"

curl -s --location --request POST https://securecloud.tufin.io/auth/realms/$TENANT/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode "username=$USERNAME" --data-urlencode "password=$PASSWORD" --data-urlencode 'client_id=express' --data-urlencode 'grant_type=password' | jq .access_token > ~/tmp/temptoken.txt

sed 's/\"//g' ~/tmp/temptoken.txt > ~/tmp/temptoken2.txt

ACCESS_TOKEN="$(cat ~/tmp/temptoken2.txt)"



curl -X 'POST' -H "Authorization: Bearer $ACCESS_TOKEN" -d '{  "name": "'"$PROJECT_NAME"'",  "mode": "LEARNING" }' \
  "https://$TENANT.securecloud.tufin.io/api/v1/orca/conf/clusters" \
  -H 'accept: */*' \
  -H 'Content-Type: application/json'
  
