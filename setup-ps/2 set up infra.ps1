# Create a custom Docker network
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