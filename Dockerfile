FROM centos:centos6

MAINTAINER Carlos Lima <carlos@cpan.org>

RUN yum install -y tar gcc bzip2

RUN cd /root && curl http://www.fefe.de/dietlibc/dietlibc-0.33.tar.bz2 | tar -jx
RUN cd /root/dietlibc-0.33 && make && install bin-*/diet /usr/local/bin

RUN cd /root && curl http://b0llix.net/perp/distfiles/perp-2.07.tar.gz | tar -zx
ADD conf.mk /root/perp-2.07/conf.mk
RUN cd /root/perp-2.07 && make && make strip

RUN yum install -y which rpm-build rpmdevtools \
        && wget ftp://ftp.pbone.net/mirror/ftp5.gwdg.de/pub/opensuse/repositories/home:/ikoinoba/CentOS_CentOS-6/x86_64/checkinstall-1.6.2-3.el6.1.x86_64.rpm \
        && rpm -i checkinstall-*.rpm \
        && rpmdev-setuptree
RUN cd /root/perp-2.07 && checkinstall -R -y --install=no --showinstall
CMD cp /root/rpmbuild/RPMS/x86_64/perp-*.rpm /root/build
