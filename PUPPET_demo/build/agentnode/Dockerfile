FROM centos:7
RUN yum -y install systemd openssh openssh-clients openssh-server iproute net-tools dmidecode tar which pciutils rsyslog tar sudo vim wget curl crontabs jq; \
    yum upgrade -y && \
    yum clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
RUN curl -LO https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
RUN chmod a+x jq-linux64
RUN mv jq-linux64 /usr/local/bin/jq
RUN rpm -Uvh https://yum.puppetlabs.com/puppet5/puppet5-release-el-7.noarch.rpm && \
    yum install -y puppet-agent && \
    yum clean all
RUN echo "root:$CONJUR_ADMIN_PASSWORD" | chpasswd
ENV PATH=/opt/puppetlabs/server/bin:/opt/puppetlabs/puppet/bin:/opt/puppetlabs/bin:$PATH
VOLUME [ “/sys/fs/cgroup” ]
ENTRYPOINT ["/usr/sbin/init"]
RUN gem install multipart-post 
RUN systemctl enable sshd.service
