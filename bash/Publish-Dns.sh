#/bin/bash

fqdnapi=$1
secret=$2
applicationname=$3
hostname=$4
ip=$5

curl -s https://$fqdnapi/api/dns/service/publish/v1 -k -H "X-c4token: $secret" -H "Content-Type: application/json" -X POST -d "{\"applicationname\":\"$applicationname\",\"hostname\":\"$hostname\",\"ip\":\"$ip\"}" | grep \"status\":\"ok\"
