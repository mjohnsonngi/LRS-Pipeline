FROM mkolmogo/card_harmonize_vcf:0.1

RUN apt-get update && \
 	apt-get upgrade -y && \
	apt-get install -y --no-install-recommends \
	libz-dev \
	libbz2-dev \
	rsync \
	zlib1g-dev \
	liblzma-dev \
	libncurses5-dev \
	libncursesw5-dev && \
	apt-get -y clean && \
	apt-get -y autoclean && \
	apt-get -y autoremove

COPY ./scripts/* /scripts/

CMD ["/bin/bash"]