# Variables Needed for the VM's Creation
$vmID = Read-Host -Prompt 'Please enter a VM ID#'
$hostName = Read-Host -Prompt 'Please enter a DNS Name (Hostname Only)'
$ipAddress = Read-Host -Prompt 'Please enter the Desired IP Address (Last Octet Only)'
$prettyName = Read-Host -Prompt 'Please Give a Pretty Name for the Server'

#Static Variables
$proxmoxVM = "{VM Name}"
$dhcpHost = "{DHCP HOST}"
$dnsHost = "{DNS HOST}"
$domain = "{example.com}"
$ipScope= "{IP Network}"

#Generated Variables
$fullhostName = $hostName+"."+$domain
$fullipAddress = $ipScope.Replace("0",$ipAddress)

#Creates the VM server
bash.exe -c  "ssh root@$proxmoxVM 'bash -s' < ~/tools/CloneProxmox.sh $vmID $fullhostName"

#Get's the MAC Address of the VM
bash.exe -c  "echo 'qm config $vmID' | ssh root@$proxmoxVM 'bash -s'" > macAddress.txt

#get's the Mac Address
Get-Content .\macAddress.txt | ForEach-Object {
    if($_ -match "net0:"){
        $mac = $_.ToString().Split("{=}")[1].Split("{,}")[0].Replace(":","")
    }
}

#Sends remote commands to configure DHCP
Invoke-Command -ComputerName $dhcpHost -ScriptBlock{Add-DhcpServerv4Reservation -ScopeID $using:ipScope -Name $using:fullhostName -Type Dhcp -IPAddress $using:fullipAddress -ClientId $using:mac}

#Sends remote commands to configure DNS
Invoke-Command -ComputerName $dnsHost -ScriptBlock{Add-DnsServerResourceRecordA -Name $using:hostName -ZoneName $using:domain -AllowUpdateAny -IPv4Address $using:fullipAddress}

#starts the server
bash.exe -c  "echo 'qm start $vmID' | ssh root@$proxmoxVM 'bash -s'"

#Waits 1 minute for server to start
start-sleep 60

# generates a popup to get users attention
$wshell = New-Object -ComObject Wscript.Shell
$wshell.Popup("Your attention is required",0,"ok",0x1)

#Configures hostname and joins server to spacewalk server
bash.exe -c  "~/tools/server_onboarding.sh $fullipAddress $fullhostName '$prettyName'"

# generates a popup to advise operations complete
$wshell = New-Object -ComObject Wscript.Shell
$wshell.Popup("Operations have completed",0,"ok",0x1)