#!/bin/bash

# Download database table from choerodon table manager

# 变量
TOKEN_URL = ${1:-"https://api.choerodon.com.cn/oauth/oauth"}

# Oauth2 token
TOKEN=$1()

# Download file
curl -H 'Content-Type: application/json' \
    -H 'Authorization: Bearer '${TOKEN} \
    -d '{"targetCodes":["exp"],"targetType":"MODULE","dataFormat":"EXCEL","latestVersionFlag":1,"__id":20978,"__status":"add"}' \
    https://api.choerodon.com.cn/rdqam/v1/934/322414854567157760/export/table \
    -o exp.xlsx