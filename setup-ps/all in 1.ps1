﻿# Create a custom Docker network
docker network create kong-net

# Start a PostgreSQL container
docker run -d --name kong-database --network=kong-net `
-e "POSTGRES_USER=kong" `
-e "POSTGRES_DB=kong" `
-e "POSTGRES_PASSWORD=kongpass" `
-p 5432:5432 `
postgres:13

# Prepare the Kong database
docker run --rm --network=kong-net `
-e "KONG_DATABASE=postgres" `
-e "KONG_PG_HOST=kong-database" `
-e "KONG_PG_PASSWORD=kongpass" `
-e "KONG_PASSWORD=test" `
kong/kong-gateway:3.2.2.1 kong migrations bootstrap

# export the license key
# $KONG_LICENSE_DATA='UPDATE IT WITH LICENCE'

# start a container with Kong Gateway
docker run -d --name kong-gateway --network=kong-net `
-e "KONG_DATABASE=postgres" `
-e "KONG_PG_HOST=kong-database" `
-e "KONG_PG_USER=kong" `
-e "KONG_PG_PASSWORD=kongpass" `
-e "KONG_PROXY_ACCESS_LOG=/dev/stdout" `
-e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" `
-e "KONG_PROXY_ERROR_LOG=/dev/stderr" `
-e "KONG_ADMIN_ERROR_LOG=/dev/stderr" `
-e "KONG_ADMIN_LISTEN=0.0.0.0:8001" `
-e "KONG_ADMIN_GUI_URL=http://localhost:8002" `
-e "KONG_LICENSE_DATA=$KONG_LICENSE_DATA" `
-p 8000:8000 -p 8443:8443 -p 8001:8001 -p 8444:8444 `
-p 8002:8002 -p 8445:8445 -p 8003:8003 -p 8004:8004 `
kong/kong-gateway:3.2.2.1
