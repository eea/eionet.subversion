#!/bin/bash

# environment variables:
# SSL_CERT - ssl cert, a pem file with public certificate
# SSL_KEY - a pem file with the unencrypted private key.
# SSL_CHAIN_CERTS - a pem file with extra certificates between the SSL_CERT and a root certificate.
# REDIRECT_HTTP - If set to a value then http on port 80 will be redirected to port 443

CONFDIR=/etc/httpd/conf.d
#CONFDIR=.
CONFIGFILE=$CONFDIR/ssl.conf

#####################################################
function install_sslkey {
    if [ -n "$SSL_KEY" ]; then
        echo "$SSL_KEY" >  /etc/pki/tls/private/localhost.key
        unset SSL_KEY
    fi
    if [ -n "$SSL_CERT" ]; then
        echo "$SSL_CERT" > /etc/pki/tls/certs/localhost.crt
        unset SSL_CERT
    fi
    if [ -n "$SSL_CHAIN_CERTS" ]; then
        echo "$SSL_CHAIN_CERTS" > /etc/pki/tls/certs/server-chain.crt
        unset SSL_CHAIN_CERTS
    fi
}

#####################################################
function create_conf {

    cat > $CONFIGFILE <<!!
<Directory "${SVN_DIR}/public/">
    AllowOverride None
    # Allow open access:
    Require all granted
</Directory>

#<VirtualHost *:80>
#ServerName server.name
DocumentRoot "${SVN_DIR}/public"
DirectoryIndex index.html
CustomLog /proc/self/fd/1 combined
ErrorLog /proc/self/fd/2
!!

    if [ -n "$REDIRECT_HTTP" ]; then
        cat >> $CONFIGFILE <<!!
RewriteEngine on
RewriteCond %{HTTPS} !=on
RewriteRule ^/?(.*) https://%{SERVER_NAME}/\$1 [R,L]
#Redirect "/" "https://${SERVER_NAME}/"
!!
    else
        cat >> $CONFIGFILE <<!!
<Location /repositories>
    DAV svn
    SVNParentPath ${SVN_DIR}/repos
    SVNIndexXSLT "/svnindex.xsl"
    AuthzSVNAccessFile ${SVN_DIR}/svnaccess

    AuthType Basic
    AuthName "${AUTH_NAME}"
    AuthBasicProvider ldap
    #AuthzLDAPAuthoritative off
    AuthLDAPURL ${LDAP_URL}
    Satisfy Any
    Require valid-user
</Location>
!!
    fi

    cat >> $CONFIGFILE <<!!
Listen 443 https

SSLPassPhraseDialog exec:/usr/libexec/httpd-ssl-pass-dialog

SSLSessionCache         shmcb:/run/httpd/sslcache(512000)
SSLSessionCacheTimeout  300

SSLRandomSeed startup file:/dev/urandom  256
SSLRandomSeed connect builtin
#SSLRandomSeed startup file:/dev/random  512
#SSLRandomSeed connect file:/dev/random  512
#SSLRandomSeed connect file:/dev/urandom 512

SSLCryptoDevice builtin

<VirtualHost _default_:443>
DocumentRoot "${SVN_DIR}/public"
DirectoryIndex index.html
CustomLog /proc/self/fd/1 combined
ErrorLog /proc/self/fd/2
#ServerName server.name

LogLevel warn

SSLEngine on
SSLProtocol all -SSLv2 -SSLv3
SSLCipherSuite HIGH:MEDIUM:!aNULL:!MD5
#SSLHonorCipherOrder on

SSLCertificateFile /etc/pki/tls/certs/localhost.crt
SSLCertificateKeyFile /etc/pki/tls/private/localhost.key
${CHAIN_CONF}
#SSLCACertificateFile /etc/pki/tls/certs/ca-bundle.crt

#CustomLog logs/ssl_request_log  "%t %h %{SSL_PROTOCOL}x %{SSL_CIPHER}x \"%r\" %b"

<Location /repositories>
    DAV svn
    SVNParentPath ${SVN_DIR}/repos
    SVNIndexXSLT "/svnindex.xsl"
    AuthzSVNAccessFile ${SVN_DIR}/svnaccess

    AuthType Basic
    AuthName "${AUTH_NAME}"
    AuthBasicProvider ldap
    #AuthzLDAPAuthoritative off
    AuthLDAPURL ${LDAP_URL}
    Satisfy Any
    Require valid-user
</Location>

</VirtualHost>
!!

}


###########################################################
# MAIN
###########################################################


SVN_DIR="/var/local/svn"
if [ -z "$LDAP_URL" ]; then
    echo "The LDAP_URL environment variable is not specified" 2>&1
    exit 2
fi

CHAIN_CONF=""
if [ -n "$SSL_CHAIN_CERTS" ]; then
    CHAIN_CONF="SSLCertificateChainFile /etc/pki/tls/certs/server-chain.crt"
fi

AUTH_NAME="${AUTH_NAME:-Subversion}"
SERVER_NAME=$(hostname)
create_conf
install_sslkey

###########################################################
# Start HTTPD
###########################################################
exec /usr/sbin/httpd -DFOREGROUND
