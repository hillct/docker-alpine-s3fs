FROM alpine:3.3

# the following ENV need to be present
ENV IAM_ROLE=none
ENV MOUNT_POINT=/var/s3
ENV RUN_STYLE=data-only
VOLUME /var/s3

ARG S3FS_VERSION=v1.79

# Workaround for current downtime of upstream Alpine Linux repo
RUN echo http://alpine.gliderlabs.com/alpine/v3.3/main > /etc/apk/repositories;

RUN apk --update add fuse alpine-sdk automake autoconf libxml2-dev fuse-dev curl-dev git bash;
RUN git clone https://github.com/s3fs-fuse/s3fs-fuse.git; \
 cd s3fs-fuse; \
 git checkout tags/${S3FS_VERSION}; \
 ./autogen.sh; \
 ./configure --prefix=/usr; \
 make; \
 make install; \
 rm -rf /var/cache/apk/*;

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
