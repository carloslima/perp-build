FROM centos:centos6

MAINTAINER Carlos Lima <carlos@cpan.org>

ADD epel.repo /etc/yum.repos.d/epel.repo
RUN yum install -y tar
RUN yum install -y bzip2
RUN yum install -y gcc

RUN cd /root && curl http://www.fefe.de/dietlibc/dietlibc-0.33.tar.bz2 | tar -jx
RUN cd /root/dietlibc-0.33 && make && install bin-*/diet /usr/local/bin

RUN cd /root && curl http://b0llix.net/perp/distfiles/perp-2.07.tar.gz | tar -zx
ADD conf.mk /root/perp-2.07/conf.mk
RUN cd /root/perp-2.07 && make && make strip
RUN cd /root/perp-2.07 && DESTDIR=/opt make install
RUN tar -C /opt -acf /root/perp-install.tgz .
#RUN cd /root/perp-2.07 && NO_INIT=1 perp-setup /etc/perp
#CMD perpboot -x /etc/perp

CMD cp /root/perp-install.tgz /root/build
