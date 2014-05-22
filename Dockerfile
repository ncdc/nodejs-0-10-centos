# nodejs-0-10-ruby
#

FROM       centos:centos6
MAINTAINER Andy Goldstein <agoldste@redhat.com>

# Pull in important updates and then install ruby193
#
RUN yum install --assumeyes centos-release-SCL && ( \
    echo "update"; \
    echo "install gettext tar which"; \
    echo "install gcc-c++ automake autoconf curl-devel openssl-devel"; \
    echo "install zlib-devel libxslt-devel libxml2-devel"; \
    echo "install mysql-libs mysql-devel postgresql-devel sqlite-devel"; \
    echo "install nodejs010-nodejs nodejs010-npm"; \
    echo "run" ) | yum shell --assumeyes && yum clean all --assumeyes


# Add configuration files, bashrc and other tweaks
#
ADD ./nodejs /opt/nodejs/

ENV STI_SCRIPTS_URL https://raw.githubusercontent.com/ncdc/nodejs-0-10-centos/master/.sti/bin

RUN mkdir -p /opt/nodejs/{run,src} && \
    mv -f /opt/nodejs/bin/node /usr/bin/node && \
    mv -f /opt/nodejs/bin/npm /usr/bin/npm

ENV APP_ROOT .
ENV HOME     /opt/nodejs
ENV PATH     $HOME/bin:$PATH

WORKDIR     /opt/nodejs/src

EXPOSE 3000

# Display STI usage when invoked outside STI builder
#
CMD ["/opt/nodejs/bin/usage"]
