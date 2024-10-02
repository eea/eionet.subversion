Eionet Subversion service
=========================

The image here expects the SVN data and configuration in /var/local/svn in the container, which you then map to a place on the host.
The SSL keys are to be given in the environment variables `SSL_KEY`, `SSL_CERT` and `SSL_CHAIN_CERTS`. The LDAP connection string in `LDAP_URL`.
If the `REDIRECT_HTTP` is not empty, then requests to port 80 will be redirected to port 443 on `SERVER_NAME`.

If you want to activate SSL without providing `SSL_KEY` and `SSL_CERT`, then set `SSL_ACTIVE` to a non-empty string. You would want to do
this if you have the key on a volume to mount.

The source code repository is https://github.com/eea/eionet.subversion.

Build instructions
------------------

Built automatically at https://hub.docker.com/r/eeacms/subversion/ when a change is
pushed to GitHub. To ensure that you always have an immutable build for production
you create a new tag in GitHub.

Make your edits...

    $ git commit -a
    $ git push
    $ version=2.1
    $ git tag -a $version -m "Release $version of the subversion container"
    $ git push origin $version

If Docker Hub doesn't build, then you can run the buildandpush.sh script to upload the image.

