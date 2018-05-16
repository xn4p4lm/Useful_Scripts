#Spacewalk Configuration for Linux Clients

#!/bin/bash
rpm -Uvh http://yum.spacewalkproject.org/2.7-client/RHEL/7/x86_64/spacewalk-client-repo-2.7-2.el7.noarch.rpm
rpm -Uvh http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install rhn-client-tools rhn-check rhn-setup rhnsd m2crypto yum-rhn-plugin
rpm -Uvh http://spacewalk.andromedaindustries.com/pub/rhn-org-trusted-ssl-cert-1.0-1.noarch.rpm
rhnreg_ks --serverUrl=https://spacewalk.andromedaindustries.com/XMLRPC --sslCACert=/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT --activationkey=1-f725118431980966881a52a03f431db3
yum -y install rhncfg rhncfg-actions rhncfg-client
rhn-actions-control --enable-all
exit