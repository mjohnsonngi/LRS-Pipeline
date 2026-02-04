FROM meredith705/card_sniffles:2.7.2

RUN apt-get update && \
 	apt-get upgrade -y && \
	apt-get install -y --no-install-recommends \
	libz-dev \
	libbz2-dev \
	rsync \
	tabix \
	zlib1g-dev \
	liblzma-dev \
	libncurses5-dev \
	libncursesw5-dev && \
	apt-get -y clean && \
	apt-get -y autoclean && \
	apt-get -y autoremove

COPY ./scripts/* /scripts/

CMD ["/bin/bash"]