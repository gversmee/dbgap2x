FROM ubuntu

RUN apt-get update -y -q && apt-get install wget -y -q
RUN wget -P / https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.9.4/sratoolkit.2.9.4-ubuntu64.tar.gz -q
RUN tar -zxf /sratoolkit.2.9.4-ubuntu64.tar.gz
RUN rm -rf /sratoolkit.2.9.4-ubuntu64.tar.gz
RUN mv /sratoolkit.2.9.4-ubuntu64/bin/* /usr/bin
RUN rm -rf /sratoolkit.2.9.4-ubuntu64



