FROM frolvlad/alpine-glibc

ENV CRAN https://cran.r-project.org
ENV R_LIBS_SITE /usr/lib/R/library

# Install system dependencies
RUN apk add --no-cache \
		R \
    R-dev \
    gcc \
		gfortran \
		g++ \
		make \
		readline-dev \
		icu-dev \
		zlib-dev \
		bzip2-dev \
		xz-dev \
		pcre-dev \
		pcre2-dev \
		libjpeg-turbo-dev \
		libpng-dev \
		tiff-dev  \
		curl \
		curl-dev \
		openblas-dev \
		zip \
		file \
		coreutils \
		bash \
    libxml2-dev \
    openssl-dev \
		openssh \
    make \
    perl \
# Gipod compat
		git \
		sudo  \
		docker \
		iptables\
# VScode compat
		libgcc \
    libstdc++


# Add default CRAN mirror
RUN echo "options(repos = c(CRAN = '${CRAN}'))" >> /usr/lib/R/etc/Rprofile.site

# sshd config
RUN echo "AllowTcpForwarding yes" >> /etc/ssh/sshd-config
RUN echo "PermitTunnel       yes" >> /etc/ssh/sshd-config

# Install littler and create symlink
RUN Rscript -e "install.packages(c('littler', 'docopt'), INSTALL_opts = c('--no-docs', '--no-html'))"  && \
    ln -s ${R_LIBS_SITE}/littler/examples/install.r /usr/local/bin/install.r && \
    ln -s ${R_LIBS_SITE}/littler/examples/install2.r /usr/local/bin/install2.r && \
    ln -s ${R_LIBS_SITE}/littler/bin/r /usr/local/bin/r

# Install tidyverse
# RUN install2.r -n 4 tidyverse

# Set the default library path
ENV R_LIBS_USER=/usr/local/lib/R/site-library

# Gitpod user setup
# Add gitpod user
RUN echo '%gitpod ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/gitpod
RUN addgroup -g 33333 gitpod && adduser -u 33333 -G gitpod -h /home/gitpod -s /bin/bash -D gitpod
RUN mkdir /workspace && chown -hR gitpod:gitpod /workspace
WORKDIR /workspace

USER gitpod

# Optional: Additional R packages or setup
# RUN install2.r additional_packages
