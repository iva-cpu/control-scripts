Scripts to Update AWS Security Group with New Public IP Address

Content:
aws-sg.ps1     -script for Windows Powershell
aws-sg.sh      -bash script for Linux


Usage:
Windows:
- run script
- type description for new security group rule
- gets and filters security group rules
- parses not used ip address into variable through filter.json file in a current folder
- deletes old rule
- creates file "currentip" with new public ip address in a current folder.
- creates inbound rule for aws security group to gain access.
- prints new ip address into console.

Linux:
- add execute permissions to file
          chmod +x aws-sg.sh
- run script
          ./aws-sg.sh
- type description for new security group rule
- gets and filters security group rules
- parses not used ip address into variable through filter.json file in a current folder
- deletes old rule
- creates "ip.txt" file with new public ip address in a current folder
- creates "ipnew.txt" file with "/32" cidr in a current folder
- creates inbound rule for aws security group to gain access.
- prints new ip address into console.
