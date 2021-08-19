#!/bin/bash

echo -e "\033[1m Enter your Tenant Name: \033[0m" 
read tenant

echo -e "\033[1m Enter your Username: \033[0m"
read username

echo -e "\033[1m Enter your Password: \033[0m"
read -s password

echo -e "\033[1m Enter Project Name to Delete: \033[0m"
read project





TENANT=$(echo $tenant)
USERNAME=$(echo $username)
PASSWORD=$(echo $password)
PROJECT=$(echo $project)


echo -e "\033[1m Here are your details:  \033[0m"
echo
echo " Tenant = $TENANT"
echo " Username = $USERNAME"
echo " Project Name = $PROJECT"

curl -s --location --request POST https://securecloud.tufin.io/auth/realms/$TENANT/protocol/openid-connect/token --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode "username=$USERNAME" --data-urlencode "password=$PASSWORD" --data-urlencode 'client_id=express' --data-urlencode 'grant_type=password' | jq .access_token > ~/tmp/temptoken.txt

sed 's/\"//g' ~/tmp/temptoken.txt > ~/tmp/temptoken2.txt

ACCESS_TOKEN="$(cat ~/tmp/temptoken2.txt)"


curl -X 'DELETE' -H "Authorization: Bearer $ACCESS_TOKEN" \
  "https://$TENANT.securecloud.tufin.io/api/v1/orca/conf/clusters/$PROJECT" \
  -H 'accept: */*'