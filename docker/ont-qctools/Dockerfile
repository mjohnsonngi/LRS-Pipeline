FROM ubuntu:24.04

RUN apt-get update && \
 	apt-get upgrade -y && \
	apt-get install -y --no-install-recommends \
	wget \
	libz-dev \
	libbz2-dev \
	libc6 \
	rsync \
	zlib1g-dev \
	liblzma-dev \
	python3 \
	pipx \
	software-properties-common && \
	apt-get -y clean && \
	apt-get -y autoclean && \
	apt-get -y autoremove
	
ENV PIPX_HOME /usr/local/bin
	
RUN pipx install NanoPlot nanoQC NanoComp

#RUN pipx install nanoQC

RUN wget https://github.com/wdecoster/cramino/releases/download/v1.1.0/cramino-linux -O /usr/local/bin/cramino && \
	chmod +x /usr/local/bin/cramino
	
RUN cp /usr/local/bin/venvs/nanoplot/bin/NanoPlot /usr/local/bin && \
	cp /usr/local/bin/venvs/nanoqc/bin/nanoQC /usr/local/bin && \
	cp /usr/local/bin/venvs/nanocomp/bin/NanoComp /usr/local/bin
	
COPY /scripts/* /scripts/

CMD ["bash"]