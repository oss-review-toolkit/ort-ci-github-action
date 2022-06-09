ARG BASEIMAGE=ghcr.io/oss-review-toolkit/ort-ci-base
FROM $BASEIMAGE

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
