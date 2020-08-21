ARG PG_CONTAINER_VERSION=9.6

FROM postgres:${PG_CONTAINER_VERSION}
ARG PGTAP_VERSION=1.1.0

RUN apk -U add \
    alpine-sdk \
    perl \
  && git clone https://github.com/theory/pgtap \
  && cd pgtap \
  && git checkout v${PGTAP_VERSION} \
  && make \
  && make install


FROM postgres:${PG_CONTAINER_VERSION}

ENV PGTAP_TEST_DIR=/opt/pgtap/tests

COPY --from=0 /usr/local/share/postgresql/extension/pgtap* /usr/local/share/postgresql/extension/

RUN apk -U add \
    build-base \
    perl-dev \
  && PERL_MM_USE_DEFAULT=1 cpan TAP::Parser::SourceHandler::pgTAP \
  && apk del -r build-base \
  && install -d ${PGTAP_TEST_DIR}

COPY ./assets/docker-entrypoint-initdb.d/*.sql /docker-entrypoint-initdb.d/

RUN wget --quiet -O /usr/bin/wait-for https://raw.githubusercontent.com/eficode/wait-for/master/wait-for \
  && chmod +x /usr/bin/wait-for

VOLUME ${PGTAP_TEST_DIR}
