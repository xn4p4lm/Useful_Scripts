$command = 'systemctl set-default multi-user.target | reboot'

foreach($ip in Get-Content .\LinuxServers.txt) {
    bash.exe -c  "echo '$command' | ssh root@$ip 'bash -s'"
}