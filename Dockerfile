FROM almalinux:9.4
MAINTAINER Søren Roug <soren.roug@eea.europa.eu>

VOLUME /var/local/svn

EXPOSE 80 443

COPY entrypoint.sh /

RUN chmod 755 /entrypoint.sh \
    && yum install -y epel-release httpd mod_ssl mod_dav_svn subversion mod_ldap python3-subversion

CMD /entrypoint.sh
