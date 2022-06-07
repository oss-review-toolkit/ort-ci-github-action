ARG BASEIMAGE=ghcr.io/janderssonse/ort-ci-base
FROM $BASEIMAGE

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
