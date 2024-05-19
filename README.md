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
  caddy-waf:
    image: ghcr.io/altersec/caddy-waf:latest
    build:
      context: ./caddy-waf/.
    container_name: caddy-waf
    restart: always
    command: ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile", "--watch"]
    ports:
      - "80:80"
      - "443:443"
      - "443:443/udp"
    volumes:
      - caddy_data:/data
      - ./caddy-waf/Caddyfile:/etc/caddy/Caddyfile
      - ./caddy-waf/extras:/etc/caddy/extras
      - ./caddy-waf/coraza:/opt/coraza/config
    networks:
      - proxy
```
