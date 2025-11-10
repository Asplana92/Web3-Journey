📘 Improved Docker Single-Node Guide (Monad)

Simplified, production-friendly setup for running a single-node Monad environment with Docker.
Includes .env variables, docker-compose.yml, health checks, logs, metrics (Prometheus/Grafana ready), and troubleshooting tips.

1) Overview

This guide helps you spin up a single-node Monad quickly and cleanly.
You can use it for DevNet or Testnet (adjust the variables).

2) Prerequisites

Ubuntu 22.04+ (or any recent Linux)

Docker + Docker Compose plugin

A non-root user with sudo or run as root

Open ports (example): 26656 (p2p), 26657 (RPC), 8545 (HTTP RPC, if enabled), 9100/9113/9090/3000 for monitoring stack (optional)

Install Docker (if needed):
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
3) Directory layout
/opt/monad
├─ .env
├─ docker-compose.yml
└─ data/
Create it:
sudo mkdir -p /opt/monad/data
cd /opt/monad
4) .env.example
NETWORK=testnet
P2P_PORT=26656
RPC_PORT=26657
HTTP_RPC_PORT=8545
PUBLIC_ADDR=
DATA_DIR=/opt/monad/data
MONAD_IMAGE=monadxyz/monad-bft:latest
BOOT_PEERS=
ENABLE_METRICS=true
Copy and edit:
cp .env.example .env
nano .env
5) docker-compose.yml
version: "3.8"
services:
  monad:
    container_name: monad
    image: ${MONAD_IMAGE}
    restart: unless-stopped
    env_file:
      - .env
    command: >
      monad
      --network ${NETWORK}
      --p2p.laddr tcp://0.0.0.0:${P2P_PORT}
      --rpc.laddr tcp://0.0.0.0:${RPC_PORT}
      --rpc.http.addr 0.0.0.0:${HTTP_RPC_PORT}
      --p2p.seeds ${BOOT_PEERS}
      --moniker ${PUBLIC_ADDR}
    volumes:
      - ${DATA_DIR}:/var/lib/monad
    ports:
      - "${P2P_PORT}:${P2P_PORT}/tcp"
      - "${RPC_PORT}:${RPC_PORT}/tcp"
      - "${HTTP_RPC_PORT}:${HTTP_RPC_PORT}/tcp"
    healthcheck:
      test: ["CMD", "curl", "-fsS", "http://127.0.0.1:${RPC_PORT}/status"]
      interval: 30s
      timeout: 5s
      retries: 10
6) Start / Stop / Logs
docker compose up -d
docker ps
docker logs -f monad
docker compose down
7) Verify
curl -s http://127.0.0.1:${RPC_PORT}/status | jq
ss -ltnp | grep ${P2P_PORT}
curl -s http://127.0.0.1:${HTTP_RPC_PORT}/ | head
8) Monitoring
Run Prometheus, Grafana, and Node Exporter if you want full visibility.
9) Security

Don’t expose RPC write methods publicly.

Use HTTPS reverse proxy (nginx/Caddy).

Enable firewall (ufw) and SSH key access.

Credits

Adapted from the official monad-xyz/monad-bft Docker repo for simplified node operation and community use.
