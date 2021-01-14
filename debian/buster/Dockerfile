FROM debian

ENV VERSION=${RELEASE_VERSION}

ENV WORKDIR=/opt

WORKDIR ${WORKDIR}

RUN echo "installing dependencies" && apt-get update \
        && apt-get install -y build-essential libcurl4-openssl-dev cmake pkg-config libasound2-dev \
        && apt-get -y install libssl-dev git libjansson-dev \
        && ldconfig

RUN echo "cloning VoIP Perf" \
        && git clone https://github.com/arsperger/voip_perf.git \
        && cd voip_perf \
        && git checkout ${VERSION} \
        && git submodule update --init

RUN echo "building (configure) PJLIB" && cd voip_perf \
        && cd pjproject && ./configure --disable-libwebrtc

RUN echo "building (make) PJLIB .." && cd voip_perf \
        && cd pjproject && make dep && make && make install

RUN echo "building VoIP Perf" && cd voip_perf \
        && cmake CMakeLists.txt \
        && make \
        && chmod +x /opt/voip_perf/voip_perf

ENV WORKDIR_BIN=/opt/voip_perf/bin
WORKDIR ${WORKDIR_BIN}

RUN mv /opt/voip_perf/voip_perf ${WORKDIR_BIN}
COPY scripts .

ENV PATH="$PATH:${WORKDIR_BIN}"

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["./help"]