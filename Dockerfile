ARG CADDY_VERSION=2.8.4

FROM caddy:${CADDY_VERSION}-builder-alpine AS builder
RUN  xcaddy build \
    --with github.com/corazawaf/coraza-caddy/v2

ARG CRS_RELEASE=4.4.0

RUN set -eux; \
    apk add --no-cache \
        ca-certificates \
        curl \
        gnupg; \
    mkdir /opt/owasp-crs; \
    curl -sSL https://github.com/coreruleset/coreruleset/archive/v${CRS_RELEASE}.tar.gz -o v${CRS_RELEASE}.tar.gz; \
    curl -sSL https://github.com/coreruleset/coreruleset/releases/download/v${CRS_RELEASE}/coreruleset-${CRS_RELEASE}.tar.gz.asc -o coreruleset-${CRS_RELEASE}.tar.gz.asc; \
    gpg --fetch-key https://coreruleset.org/security.asc; \
    gpg --verify coreruleset-${CRS_RELEASE}.tar.gz.asc v${CRS_RELEASE}.tar.gz; \
    tar -zxf v${CRS_RELEASE}.tar.gz --strip-components=1 -C /opt/owasp-crs; \
    rm -f v${CRS_RELEASE}.tar.gz coreruleset-${CRS_RELEASE}.tar.gz.asc; 

FROM caddy:${CADDY_VERSION}-alpine AS final
RUN  rm -rf /usr/share/caddy/ && \
    apk --update-cache upgrade && \
    find /usr/sbin /usr/bin /sbin /bin -delete -executable -not -iname '*.so*' -a -not -type d
 
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY --from=builder /opt/owasp-crs/rules /opt/owasp-crs/rules

COPY Caddyfile /etc/caddy/Caddyfile
COPY extras /etc/caddy/extras
COPY coraza /etc/caddy/config
