# Use Ubuntu as base (same as GitHub Actions)
FROM ubuntu:22.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Build version - increment this to force a rebuild when tools/libraries update
ARG BUILD_VERSION=1
ENV BUILD_VERSION=${BUILD_VERSION}

# Install required system packages
RUN apt-get update && apt-get install -y \
	bash \
    curl \
    git \
    python3 \
    python3-pip \
    sed \
    findutils \
    && rm -rf /var/lib/apt/lists/*

# Install esptool (for flashing, though not needed for building)
RUN pip3 install esptool

# Install Arduino CLI
RUN curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh && \
    mv bin/arduino-cli /usr/local/bin/ && \
    rm -rf bin

# Set working directory
WORKDIR /workspace

# Copy build script
COPY docker-build.sh /usr/local/bin/docker-build.sh
RUN ["chmod", "+x", "/usr/local/bin/docker-build.sh"]

# Default command
CMD ["bash", "/usr/local/bin/docker-build.sh"]



