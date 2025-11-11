# Deploying on Monad

This guide explains how to deploy a Monad node using Docker.  
It is suitable for developers, RPC operators, and community builders joining the Testnet.

---

## 1. System requirements
- Ubuntu 22.04 or later  
- 4+ CPU, 8 GB RAM  
- Docker + Docker Compose plugin  
- Open ports 26656 (p2p) and 26657 (RPC)

---

## 2. Install Docker
```bash
sudo apt update && sudo apt install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin


3. Configuration

Create a working directory and .env file:

MONAD_IMAGE=monadxyz/monad-node:latest
NETWORK=testnet
RPC_PORT=26657
P2P_PORT=26656
DATA_DIR=/opt/monad

4. Start the node
docker compose up -d

Check node status:
curl http://127.0.0.1:26657/status
If the output returns block information, your node is running successfully.



---

## 5. Monitoring and maintenance
- Integrate Prometheus + Grafana for metrics  
- Add a systemd unit for auto-restart  
- Regularly update the Docker image to stay synced with Testnet releases

---

**Author:** Tolik | Infra Builder  
Community contribution for Monad documentation

