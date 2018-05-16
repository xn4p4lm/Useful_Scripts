#!/bin/bash 
echo "Server IP: " $1
echo "New Host Name: " $2
echo "Pretty Host Name: " $3
echo "Please Verify the Information - Press Enter to Continue or CMD - C to Exit"
read hold

echo "Copying over the SSH keys"
ssh-copy-id -i ~/tools/sshKey/id_rsa.pub root@$1 

echo "yum -y upgrade" | ssh -o ConnectTimeout=1 -o ConnectionAttempts=1 root@$1 'bash -s'

echo "setting Static Hostname"
echo "hostnamectl set-hostname --static " $2 | ssh -o ConnectTimeout=1 -o ConnectionAttempts=1 root@$1 'bash -s'

echo "setting Prtty Hostname"
echo "hostnamectl set-hostname --pretty " "'"$3"'" | ssh -o ConnectTimeout=1 -o ConnectionAttempts=1 root@$1 'bash -s'

echo "Confirming Hostname"
echo "hostnamectl" | ssh -o ConnectTimeout=1 -o ConnectionAttempts=1 root@$1 'bash -s'

echo "Setting up the Spacewalk connection"
ssh -o ConnectTimeout=1 -o ConnectionAttempts=1 root@$1 'bash -s' < ~/tools/config_remote.sh

exit 