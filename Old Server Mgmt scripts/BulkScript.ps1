foreach($ip in Get-Content .\LinuxServers.txt) {
    bash.exe -c  "ssh root@$ip 'bash -s' < ~/tools/script.sh"
}