# Base
FROM docker.io/rockylinux/rockylinux:8
LABEL maintainer="Damian Troy <github@black.hole.com.au>"
RUN dnf -y update && dnf clean all

# Common
ENV PUID=1001
ENV PGID=1001
RUN groupadd -g "$PGID" videos && \
    useradd --no-log-init -u "$PUID" -g videos -d /config -M videos && \
    install -d -m 0755 -o videos -g videos /config /videos
ENV TZ=Australia/Melbourne
ENV LANG=C.UTF-8
COPY test.sh /usr/local/bin/

# App
RUN dnf -y install nmap-ncat gzip wget && \
    dnf -y install libicu && \
    dnf clean all
RUN wget -O /tmp/Lidarr.master.tar.gz "https://lidarr.servarr.com/v1/update/master/updatefile?os=linux&runtime=netcore&arch=x64" && \
    tar -xvf /tmp/Lidarr.master.tar.gz -C /opt/ && \
    mkdir -p /opt/lidarr && \
    mv /opt/Lidarr /opt/lidarr/bin && \
    rm -f /tmp/Lidarr.master.tar.gz && \
    chown -R "$PUID:$PGID" /opt/lidarr

# Runtime
VOLUME /config /videos
EXPOSE 8686
USER videos
CMD ["/opt/lidarr/bin/Lidarr","-nobrowser","-data=/config"]
