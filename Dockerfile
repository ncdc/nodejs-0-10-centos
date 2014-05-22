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

# Set the 'root' directory where this build will search for Gemfile and
# config.ru.
#
# This can be overridden inside another Dockerfile that uses this image as a base
# image or in STI via the '-e "APP_ROOT=subdir"' option.
#
# Use this in case when your application is contained in a subfolder of your
# GIT repository. The default value is the root folder.
#
ENV APP_ROOT .
ENV HOME     /opt/ruby
ENV PATH     $HOME/bin:$PATH

WORKDIR     /opt/ruby/src
USER ruby

EXPOSE 9292

# Display STI usage when invoked outside STI builder
#
CMD ["/opt/ruby/bin/usage"]
