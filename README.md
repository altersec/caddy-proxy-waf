# Caddy Reverse Proxy and WAF

Based on:
https://github.com/corazawaf/coraza-caddy

## Config

Review the config in the coraza folder or extras

coraza\RULE-EXCEPTIONS.conf is where the rule exceptions should be made

## BUILD
```
docker buildx -t altersec/caddy-proxy-waf .
docker buildx build --push --tag altersec/caddy-proxy-waf:latest .
```

## RELOAD
```
docker compose exec -w /etc/caddy caddy-proxy-waf caddy reload
docker compose exec -w /etc/caddy caddy-proxy-waf caddy fmt --overwrite
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

## Custom app

mkdir -p custom
cp -r Caddyfile coraza extras custom/.

## Test

docker compose up
Run ./scripts/test.sh and check if all responses match
docker compose down -f

Try different backends.

### Wordpress
docker compose -f docker-compose.yml -f docker-compose.wptest.yml up
./scripts/test.sh
docker compose -f docker-compose.yml -f docker-compose.wptest.yml down -v

# Logs

sudo chmod go+r ./logs/*