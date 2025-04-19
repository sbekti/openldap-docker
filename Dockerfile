FROM    ubuntu:noble
LABEL   maintainer=samudra.bekti@gmail.com

ARG     OPENLDAP_PACKAGE_VERSION=2.6.7*

RUN     apt-get update \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
            procps net-tools \
            ldap-utils=${OPENLDAP_PACKAGE_VERSION} \
            slapd=${OPENLDAP_PACKAGE_VERSION} \
            slapd-contrib=${OPENLDAP_PACKAGE_VERSION} \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN     rm -rf /var/lib/ldap /etc/ldap/slapd.d

COPY    docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE  389 636

ENTRYPOINT  ["/docker-entrypoint.sh"]
CMD         ["slapd", "-d", "32768", "-h", "ldap://:389/ ldapi:/// ldaps://:636/"]
