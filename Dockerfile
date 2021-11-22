FROM alpine:3.11.6

RUN apk add --no-cache \
        postgresql-client \
        zstd \
        curl \
        python3 \
        py3-crcmod \
        bash \
        libc6-compat \
        openssh-client \
        git \
        gnupg \
    && curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-294.0.0-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-*.tar.gz && \
    rm google-cloud-sdk-*.tar.gz

ADD script.sh /script.sh

CMD ["bash", "/script.sh"]