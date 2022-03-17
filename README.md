# Lidarr music collection manager Rocky Linux container

This is a Rocky Linux 8 container for [Lidarr](https://lidarr.audio/), which keeps track of and organises your music library.

## Building

To build and test the image, run:

```shell script
make all # build test
```

### Configuration

| Command | Config   | Description
| ------- | -------- | -----
| ENV     | PUID     | UID of the runtime user (Default: 1001)
| ENV     | PGID     | GID of the runtime group (Default: 1001)
| ENV     | TZ       | Timezone (Default: Australia/Melbourne)
| VOLUME  | /videos  | Media directory, including 'downloads/'
| VOLUME  | /config  | Configuration directory
| EXPOSE  | 8686/tcp | HTTP port for web interface

```shell script
PUID=1001
PGID=1001
TZ=Australia/Melbourne
VIDEOS_DIR=/videos
LIDARR_CONFIG_DIR=/etc/lidarr
LIDARR_IMAGE=localhost/lidarr # Or damiantroy/lidarr if deploying from docker.io

sudo mkdir -p "$VIDEOS_DIR" "$LIDARR_CONFIG_DIR"
sudo chown -R "$PUID:$PGID" "$VIDEOS_DIR" "$LIDARR_CONFIG_DIR"

sudo podman run -d \
    --name=lidarr \
    --network=host \
    -e PUID="$PUID" \
    -e PGID="$PGID" \
    -e TZ="$TZ" \
    -v "$LIDARR_CONFIG_DIR:/config:Z" \
    -v "$VIDEOS_DIR:/videos:z" \
    "$LIDARR_IMAGE"
```
