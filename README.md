Eionet Subversion service
=========================

The image here expects the SVN data and configuration in /var/local/svn in the container, which you then map to a place on the host.
The SSL keys are to be given in the environment variables SSL_KEY, SSL_CERT and SSL_CHAIN_CERTS. The LDAP connection string in LDAP_URL.

The source code repository is https://github.com/eea/eionet.subversion.

Build instructions
------------------

Built automatically at https://hub.docker.com/r/eeacms/subversion/ when a change is
pushed to GitHub. To ensure that you always have an immutable build for produuction
you create a new tag in GitHub.

    $ version=v1.3
    $ git tag -a $version -m "Release $version of the subversion container"
    $ git push origin $version

Docker Hub has, however, consistently been unable to build due to a
cap_set_file error. In that case you can run the buildandpush.sh script
to upload the image.

