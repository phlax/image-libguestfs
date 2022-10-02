from gpt4/python3.10

ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update -qq \
    && apt-get install -y -qq --no-install-recommends \
               git \
               libguestfs-tools \
               linux-image-generic \
    && mkdir -p /workspace \
    && chown -R pyuser:pyuser /workspace

COPY ./fetch.sh /fetch.sh
COPY ./run.sh /run.sh
COPY ./cleanup.sh /cleanup.sh

USER pyuser
WORKDIR /workspace
CMD ["/run.sh"]
