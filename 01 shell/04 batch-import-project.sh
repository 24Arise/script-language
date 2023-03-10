#!/bin/bash

# Download Table List from Table Design Management

## Declare Variable
declare -A SERVICES
SERVICES["【产研】档案影像服务"]="hfins-ecm"
SERVICES["【产研】考评计算服务"]="hfins-esr"
SERVICES["【产研】智能审核服务"]="hfins-ids"
SERVICES["【产研】资金服务"]="hfins-fm"
SERVICES["【产研】资金计划服务"]="hfins-cpln"
SERVICES["【产研】银企直连服务"]="hfins-ebank"
SERVICES["【产研】智能收单服务"]="hfins-irm"
SERVICES["【产研】会计引擎服务"]="hscs-accounts-engine"
SERVICES["【产研】数据集成服务"]="hscs-data-integration"
SERVICES["【产研】取数模型服务"]="hscs-data-transfer"

# Variable
TOKEN_URL="https://api.choerodon.com.cn/oauth/oauth/token"
CLIENT_ID="MeWxmTJbbOFv"
CLIENT_SECRET="kiOgr2g4rfkBdKtM"
GRANT_TYPE="client_credentials"
API_URL="https://api.choerodon.com.cn/devops/v1/projects/291571058753736704/app_service/import/external"


# Oauth2 token
token="$(curl -s -H "Content-Type: application/x-www-form-urlencoded" -X POST -d "client_id=${CLIENT_ID}&client_secret=${CLIENT_SECRET}&grant_type=${GRANT_TYPE}" $TOKEN_URL | jq -r ".access_token")"
echo $token

echo ${!SERVICES[*]}

# Inter
for key in ${!SERVICES[*]}; do
  # parameter
    service_code=${SERVICES[$key]}
    service_name=${key}

  # starter import service
  echo "import ${service_code} ${service_name} ......"

#  curl -s $API_URL \
#    -H 'Content-Type: application/json' \
#    -H "Authorization: bearer ${token}" \
#    -X POST \
#    -d '{"code":"'$service_code'","name":"'$service_name'","repositoryUrl":"https://code.choerodon.com.cn/org-fin-hfins/'$service_code'.git","accessToken":"glpat-L-S86oM82Fgpzb5Tg-xN","type":"normal"}'
done
