#!/bin/bash

# Download Table List from Table Design Management

# Variable
TOKEN_URL="https://api.choerodon.com.cn/oauth/oauth/token"
CLIENT_ID="uICMDo8gZeR9"
CLIENT_SECRET="PQN2SF5DoMCH7G4w"
GRANT_TYPE="client_credentials"
API_URL="https://api.choerodon.com.cn/rdqam/v1/934/322414854567157760/export/table"
MODULE="hsae hscs hsdt hspm hsdi ids esr ctrip bpm gld fnd map exp acru fam eam acr accrual ecm acp bgt sys pur ebank gl con ssc wfl wbc csh mdm inv fdm prj ptl lock vat himp evt att app ord"

# Oauth2 token
token="$(curl -s -H "Content-Type: application/x-www-form-urlencoded" -X POST -d "client_id=${CLIENT_ID}&client_secret=${CLIENT_SECRET}&grant_type=${GRANT_TYPE}" $TOKEN_URL | jq -r ".access_token")"
#echo $token

# Download file
for module in $MODULE; do
  # shellcheck disable=SC2021
  file_name="上海汉得_智慧财务-技术设计-$(echo "$module" | tr '[a-z]' '[A-Z]')-表设计.xlsx"
  echo "Download ${file_name} ......"

  curl -s -H 'Content-Type: application/json' \
    -H "Authorization: Bearer ${token}" \
    -d "{\"targetCodes\":[\"${module}\"],\"targetType\":\"MODULE\",\"dataFormat\":\"EXCEL\",\"latestVersionFlag\":1,\"__id\":20978,\"__status\":\"add\"}" \
    $API_URL \
    -o "$file_name"
done
