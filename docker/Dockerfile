FROM centos:centos7

# Note to myself:
# build using docker build -t bench:v1 .
# run using docker run -it --entrypoint /bin/bash bench:v1


RUN yum update -y
RUN yum install -y wget && wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u101-b13/jdk-8u101-linux-x64.rpm
RUN rpm -ivh jdk-8u101-linux-x64.rpm && rm jdk-8u101-linux-x64.rpm
RUN \
	yum clean metadata && \
	yum -y install epel-release && \
	yum clean metadata && \
	yum -y install which make tar rpm-build yum-utils python-argparse python-yaml gcc gcc-c++ createrepo git-all python-jinja2 python-devel ruby-rdoc ruby-devel rubygems glib*&& \
	yum clean all


# Uncomment the following lines to
# build Docker image with downloaded buildsystems (1GB)
#RUN mkdir build-bench
#RUN cd build-bench; git init
#RUN cd build-bench; git remote add origin https://github.com/tkruse/build-bench.git
#RUN cd build-bench; git fetch --tags; git checkout centos-0.0.1
#RUN cd build-bench; make
