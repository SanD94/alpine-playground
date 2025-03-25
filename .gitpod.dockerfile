FROM r-base:alpine

# Install system dependencies
RUN apk add --no-cache \
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
RUN R -e "install.packages('littler', repos = 'http://cran.us.r-project.org')" && \
    ln -s /usr/local/lib/R/site-library/littler/examples/install.r /usr/local/bin/install.r

# Create a directory for R packages
RUN mkdir -p /usr/local/lib/R/site-library

# Install tidyverse
RUN install.r tidyverse

# Set the default library path
ENV R_LIBS_USER=/usr/local/lib/R/site-library

# Gitpod user setup
# Add gitpod user
RUN echo '%gitpod ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/gitpod \
RUN addgroup -g 33333 gitpod && adduser -u 33333 -G gitpod -h /home/gitpod -s /bin/bash -D gitpod
WORKDIR /workspace

# Optional: Additional R packages or setup
# RUN install.r additional_packages

CMD ["R"]
