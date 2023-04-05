# Use the official Haskell image as the base image
FROM haskell:9.4 AS builder

# Install the necessary dependencies
RUN apt-get update && \
    apt-get install -y git

# Set the working directory to /app
WORKDIR /app

# Copy the Cabal file and the source code to the container
COPY . .

# Build the executable using Cabal
RUN cabal update && \
    cabal build

# Set the base image to Debian Buster slim
FROM debian:buster-slim

# Install any runtime dependencies
RUN apt-get update && \
    apt-get install -y libgmp-dev

# Copy the executable from the previous build stage
COPY --from=builder /app/dist-newstyle/build/x86_64-linux/ghc-9.4.4/hs-docker-image-0.1.0.0/x/hs-docker-image/build/hs-docker-image/hs-docker-image .

# Set the command to run when the container starts
CMD ["./hs-docker-image"]
