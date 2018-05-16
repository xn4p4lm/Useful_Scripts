#sets the Hostname of the machine and the pretty name
#!/bin/bash
echo "hostname " $1
echo "pretty " $2

hostnamectl set-hostname --pretty $2
exit