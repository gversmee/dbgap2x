FROM centos:6

RUN yum update -y -q && yum install wget -y -q && yum clean all -y -q && \
wget -P / https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-centos_linux64.tar.gz -q && \
tar -zxf /sratoolkit.current-centos_linux64.tar.gz '*/bin/' && \
rm -rf /sratoolkit.current-centos_linux64.tar.gz && \
mv /sratoolkit.2.9.2-centos_linux64/bin/* /usr/bin && \
rm -rf /sratoolkit.2.9.2-centos_linux64
