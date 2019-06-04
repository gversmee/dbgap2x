FROM ubuntu

RUN apt-get update -y -q && apt-get install wget -y -q && apt-get clean
RUN wget -P / https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.9.4/sratoolkit.2.9.4-ubuntu64.tar.gz -q \
&& tar -zxf /sratoolkit.2.9.4-ubuntu64.tar.gz \
&& rm -rf /sratoolkit.2.9.4-ubuntu64.tar.gz \
&& mv /sratoolkit.2.9.4-ubuntu64/bin/* /usr/bin \
&& rm -rf /sratoolkit.2.9.4-ubuntu64
