FROM alpine

RUN apk update && apk add curl && rm -rf /var/cache/apk/*


RUN curl -O https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.9.4/sratoolkit.2.9.4-ubuntu64.tar.gz -q \
	&& tar -zxf ./sratoolkit.2.9.4-ubuntu64.tar.gz \
	&& rm -rf ./sratoolkit.2.9.4-ubuntu64.tar.gz \
	&& mv ./sratoolkit.2.9.4-ubuntu64/bin/* /usr/bin \
	&& rm -rf ./sratoolkit.2.9.4-ubuntu64
