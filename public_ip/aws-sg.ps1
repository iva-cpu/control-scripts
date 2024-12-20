# enter rule description and pass it to variable
param (
    [Parameter(Mandatory=$true)][string]$Description
 )
# get and filter security group rules
aws ec2 describe-security-group-rules --filters Name=group-
id,Values=sg-"" --query "SecurityGroupRules[*].{IP:CidrIpv4,ID:Description}" > filter.json

# parse not used ip address into variable
$data = Get-Content .\filter.json | Out-String | ConvertFrom-Json
$data = Write-Output $data | Where-Object {$_.ID -match "$Description"}
$ipNotUsed = $data.IP
# print not used ip address
Write-Output $ipNotUsed

# delete old rule
aws ec2 revoke-security-group-ingress --group-id sg-"" --ip-permissions IpProtocol=tcp,FromPort=22,ToPort=22,IpRanges="[{CidrIp=$ipNotUsed}]"

# get public ip address
$ipinfo = Invoke-RestMethod http://ipinfo.io/json
# create file "currentip" with ip address got
$ipinfo.ip | out-file -filepath currentip -NoNewLine
# add cidr "/32" to ip address
$ipCidr = Add-Content -Path "currentip" -Value "/32"
# set value into variable
$ipCidr = Get-Content -Path "currentip"

# create rule for aws security group to get access
aws ec2 authorize-security-group-ingress --group-id sg-"" --ip-permissions IpProtocol=tcp,FromPort=22,ToPort=22,IpRanges="[{CidrIp=$ipCidr,Description="$Description"}]"

# print new ip address to console
Write-Output $ipCidr
