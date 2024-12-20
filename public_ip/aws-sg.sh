#!/bin/bash
# enter description for newly created rule and pass it to variable
echo Enter description:
read DESCRIPTION
# get and filter security group rules
aws ec2 describe-security-group-rules \
      --filters Name=group-id,Values=sg-"" \
      --query "SecurityGroupRules[*].{IP:CidrIpv4,ID:Description}" > filter.json
# get ip address filtered by entered description
ipNotUsed=$(jq .[] filter.json | xargs -n 6 | grep $DESCRIPTION | grep -o '[0-9]\+[.][0-9]\+[.][0-9]\+[.][0-9]\+')
ipNotUsed+="/32"
echo $ipNotUsed
# delete old rule
aws ec2 revoke-security-group-ingress \
    --group-id sg-"" \
    --ip-permissions IpProtocol=tcp,FromPort=22,ToPort=22,IpRanges=[{CidrIp=$ipNotUsed}]

# pull current public IP address
curl v4.ifconfig.co > ip.txt
awk '{ print $0 "/32" }' < ip.txt > ipnew.txt
export ipCidr=$(cat ipnew.txt)

# add a rule to EC2 security group allowing SSH access
aws ec2 authorize-security-group-ingress \
              --group-id sg-"" \
              --ip-permissions IpProtocol=tcp,FromPort=22,ToPort=22,IpRanges='[{CidrIp='$ipCidr',Description="'$DESCRIPTION'"}]'
# print new ip address to console
echo $ipCidr
