Eionet Subversion service
=========================

The image here expects the SVN data and configuration in /var/local/svn in the container, which you then map to a place on the host.
The SSL keys are to be given in the environment variables SSL_KEY, SSL_CERT and SSL_CHAIN_CERTS. The LDAP connection string in LDAP_URL.

