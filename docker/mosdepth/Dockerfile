FROM ubuntu:20.04

RUN apt-get update && \
 	apt-get upgrade -y && \
	apt-get install -y --no-install-recommends \
	wget \
	libz-dev \
	libbz2-dev \
	zlib1g-dev \
	liblzma-dev && \
	apt-get -y clean && \
	apt-get -y autoclean && \
	apt-get -y autoremove
	
RUN wget --no-check-certificate https://github.com/brentp/mosdepth/releases/download/v0.3.12/mosdepth -O /usr/local/bin/mosdepth && \
	chmod +x /usr/local/bin/mosdepth
	
COPY /scripts/* /scripts/

CMD ["bash"]