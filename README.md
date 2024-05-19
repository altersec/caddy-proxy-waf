# Caddy Reverse Proxy and WAF

Based on:
https://github.com/corazawaf/coraza-caddy

## Config

Review the config in the coraza folder or extras

coraza\RULE-EXCEPTIONS.conf is where the rule exceptions should be made

## BUILD
```
docker build -t altersec/caddy-waf .
docker buildx build --push --tag altersec/caddy-waf:latest .
```

## RELOAD
```
docker compose exec -w /etc/caddy caddy-waf caddy reload
docker compose exec -w /etc/caddy caddy-waf caddy fmt --overwrite
```

## docker-compose example
```
  caddy-proxy-waf:
    image: ghcr.io/altersec/caddy-proxy-waf:latest
    build:
      context: ./caddy-proxy-waf/.
    container_name: caddy-proxy-waf
    restart: always
    # command: ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile", "--watch"]
    ports:
      - "80:80"
      - "443:443"
      - "443:443/udp"
    environment:
      - SERVER_NAME=${SERVER_NAME:-localhost}
    volumes:
      - caddy_data:/data
      - ./caddy-proxy-waf/Caddyfile:/etc/caddy/Caddyfile
      - ./caddy-proxy-waf/extras:/etc/caddy/extras
      - ./caddy-proxy-waf/coraza:/opt/coraza/config
      - ./caddy-proxy-waf/logs:/var/log/caddy
    networks:
      - proxy

volumes:
  caddy_data:
    driver: local

```
