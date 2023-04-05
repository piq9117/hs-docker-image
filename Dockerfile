FROM haskell:9.4 as builder

WORKDIR /build

# Install dependencies
RUN apt-get update
RUN apt-get install -y libgmp-dev \
                       zlib1g-dev \
                       libpq-dev \
                       libtinfo-dev \
                       libsodium-dev \
                       libpq5 \
                       pkg-config \
                       build-essential \
                       liblzma-dev

# Copy cabal files
COPY *.cabal /build/

USER root

RUN cabal v2-update

RUN cabal v2-install cabal-plan --constraint='cabal-plan +exe'

# Build only dependencies so they can be cached
RUN cabal v2-build -v1 --dependencies-only hs-docker-image

COPY . /build

RUN cabal build

RUN mkdir -p /build/artifacts && cp $(cabal-plan list-bin hs-docker-image) /build/artifacts/

ENTRYPOINT ["/build/artifacts/hs-docker-image"]
