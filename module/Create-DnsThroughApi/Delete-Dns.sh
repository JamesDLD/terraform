#/bin/bash

fqdnapi=$1
secret=$2
applicationname=$3
zonename=$4
hostname=$5
ip=$6

curl -s https://$fqdnapi/api/dns/host/remove/v1 -k -H "X-c4token: $secret" -H "Content-Type: application/json" -X POST -d "{\"applicationname\":\"$applicationname\",\"zonename\":\"$zonename\",\"hostname\":\"$hostname\",\"ip\":\"$ip\"}" | grep \"status\":\"ok\"