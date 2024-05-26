FROM ubuntu:22.04

ENV OSRM_VERSION="5.27.1"

WORKDIR /workspace

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    ca-certificates \
    gcc \
    cmake \
    pkg-config \
    libbz2-dev \
    libxml2-dev \
    libzip-dev \
    libboost-all-dev \
    lua5.2 \
    liblua5.2-dev \
    libluabind-dev \
    libstxxl-dev \
    libxml2 \
    libxml2-dev libosmpbf-dev libbz2-dev libzip-dev libprotobuf-dev \
    libtbb-dev && \
    # Clean up to reduce image size
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ADD https://github.com/Project-OSRM/osrm-backend/archive/v$OSRM_VERSION.tar.gz v$OSRM_VERSION.tar.gz
RUN tar xzf v$OSRM_VERSION.tar.gz

RUN cd osrm-backend-${OSRM_VERSION} \
    && export CC=$(which gcc) \
    && export CXX=$(which g++) \
    && mkdir -p build \
    && cd build \
    && cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ \
    && cmake --build . \
    && cmake --build . --target install


COPY docker-entrypoint.sh /workspace/
RUN chmod +x /workspace/docker-entrypoint.sh
CMD ["/workspace/docker-entrypoint.sh"]

EXPOSE 5000