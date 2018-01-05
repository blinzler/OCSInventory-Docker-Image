FROM centos:7

LABEL maintainer="m.brandt@globits.de"
LABEL version="2.4"
LABEL description="OCS (Open Computers and Software Inventory Next Generation)"

ENV container docker

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
    systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN yum -y install wget;\
    wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm;\
    rpm -ivh epel-release-latest-7.noarch.rpm;\
    yum makecache;\
    yum -y install httpd; systemctl enable httpd.service;\
    yum -y install mod_perl php php-gd php-imap php-ldap \
    php-mbstring php-mysqli php-pear-CAS php-soap php-xml ;\
    yum -y install make gcc;\
    yum -y install php-common;\
    yum -y install perl perl-XML-Simple perl-Compress-Zlib perl-DBI \
    perl-DBD-MySQL perl-Net-IP perl-SOAP-Lite perl-File-FcntlLock;\
    yum -y install nmap;\
    yum clean all;

COPY ./scripts/docker-download.sh /tmp/docker-download.sh

RUN sh /tmp/docker-download.sh 2.4

WORKDIR /tmp/ocs/Apache

RUN perl Makefile.PL ;\
    make ;\
    make install ;\
    rm -f /etc/localtime ;\
    cp /usr/share/zoneinfo/Europe/Berlin /etc/localtime ;\
    cp -R blib/lib/Apache /usr/local/share/perl5/ ;\
    cp -R Ocsinventory /usr/local/share/perl5/ ;\
    cp /tmp/ocs/etc/logrotate.d/ocsinventory-server /etc/logrotate.d/ ;\
    mkdir -p /etc/ocsinventory-server/plugins ;\
    mkdir -p /etc/ocsinventory-server/perl ;\
    mkdir -p /usr/share/ocsinventory-reports/ocsreports

WORKDIR /tmp/ocs

COPY dbconfig.inc.php /usr/share/ocsinventory-reports/ocsreports/

ENV HTTPD_RUN_USER     apache
ENV HTTPD_RUN_GROUP    apache
ENV HTTPD_LOG_DIR      /var/log/httpd
ENV HTTPD_PID_FILE     /var/run/httpd.pid
ENV HTTPD_RUN_DIR      /var/run/httpd
ENV HTTPD_LOCK_DIR     /var/lock/httpd
ENV HTTPD_LOG_DIR      /var/log/httpd

RUN cp -R ocsreports/* /usr/share/ocsinventory-reports/ocsreports ;\
    bash -c 'mkdir -p /var/lib/ocsinventory-reports/{download,ipd,logs,scripts,snmp}' ;\
    chmod -R +w /var/lib/ocsinventory-reports ;\
    chown apache: -R /var/lib/ocsinventory-reports ;\
    rm -f /usr/share/ocsinventory-reports/ocsreports/ipdiscover-util.pl ;\
    cp binutils/ipdiscover-util.pl /usr/share/ocsinventory-reports/ocsreports/ipdiscover-util.pl ;\
    chown apache: /usr/share/ocsinventory-reports/ocsreports/ipdiscover-util.pl ;\
    chmod 755 /usr/share/ocsinventory-reports/ocsreports/ipdiscover-util.pl ;\
    chmod +w /usr/share/ocsinventory-reports/ocsreports/dbconfig.inc.php ;\
    mkdir -p /var/log/ocsinventory-server/ ;\
    chmod +w /var/log/ocsinventory-server ;\
    chown -R apache: /usr/share/ocsinventory-reports/
    rm -f /etc/httpd/conf.d/welcome.conf

COPY /conf/ocsinventory-reports.conf /conf/z-ocsinventory-server.conf /conf/welcome.conf /etc/httpd/conf.d/
COPY ./scripts/run.sh /root/run.sh

# forward logs to docker log collector
RUN ln -sf /dev/stdout /var/log/ocsinventory-server

EXPOSE 80
EXPOSE 443

VOLUME /sys/fs/cgroup

CMD ["/bin/bash", "/root/run.sh"]