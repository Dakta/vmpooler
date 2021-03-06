# Run vmpooler in a Docker container!  Configuration can either be embedded
# and built within the current working directory, or stored in a
# VMPOOLER_CONFIG environment value and passed to the Docker daemon.
#
# BUILD:
#   docker build -t vmpooler .
#
# RUN:
#   docker run -e VMPOOLER_CONFIG -p 80:4567 -it vmpooler

FROM jruby:9.1-jdk

RUN mkdir -p /var/lib/vmpooler

WORKDIR /var/lib/vmpooler

ADD Gemfile* /var/lib/vmpooler/
RUN bundle install --system

RUN ln -s /opt/jruby/bin/jruby /usr/bin/jruby

COPY . /var/lib/vmpooler

ENV VMPOOLER_LOG /var/log/vmpooler.log
CMD \
    /var/lib/vmpooler/scripts/vmpooler_init.sh start \
    && while [ ! -f ${VMPOOLER_LOG} ]; do sleep 1; done ; \
    tail -f ${VMPOOLER_LOG}
