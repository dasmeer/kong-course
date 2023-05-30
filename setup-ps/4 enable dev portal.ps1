echo "KONG_PORTAL_GUI_HOST=localhost:8003 KONG_PORTAL=on kong reload exit" `
  | docker exec -i kong-gateway //bin//sh