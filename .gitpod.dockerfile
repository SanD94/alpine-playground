FROM alpine:latest

# Install system dependencies
RUN apk add --no-cache \
		R \
    R-dev \
    gcc \
    musl-dev \
    libxml2-dev \
    curl-dev \
    openssl-dev \
    make \
    perl \
    git

# Install littler and create symlink
RUN Rscript -e "install.packages('littler)" && \
    ln -s /usr/local/lib/R/site-library/littler/examples/install.r /usr/local/bin/install.r
    ln -s /usr/local/lib/R/site-library/littler/examples/install2.r /usr/local/bin/install2.r

# Create a directory for R packages
RUN mkdir -p /usr/local/lib/R/site-library

# Install tidyverse
RUN install2.r tidyverse

# Set the default library path
ENV R_LIBS_USER=/usr/local/lib/R/site-library

# Gitpod user setup
# Add gitpod user
RUN echo '%gitpod ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/gitpod \
RUN addgroup -g 33333 gitpod && adduser -u 33333 -G gitpod -h /home/gitpod -s /bin/bash -D gitpod
WORKDIR /workspace

# Optional: Additional R packages or setup
# RUN install2.r additional_packages

CMD ["R"]
