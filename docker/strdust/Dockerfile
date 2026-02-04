FROM ubuntu:20.04

RUN apt-get update && \
 	apt-get upgrade -y && \
	apt-get install -y --no-install-recommends \
	libz-dev \
	libbz2-dev \
	rsync \
	wget \
	tabix \
	zlib1g-dev \
	liblzma-dev \
	libncurses5-dev \
	libncursesw5-dev && \
	apt-get -y clean && \
	apt-get -y autoclean && \
	apt-get -y autoremove

RUN wget -P /usr/local/bin/ https://github.com/wdecoster/STRdust/releases/download/v0.14.0/STRdust-linux \
&& chmod +x /usr/local/bin/STRdust-linux

COPY ./scripts/* /scripts/

CMD ["/bin/bash"]