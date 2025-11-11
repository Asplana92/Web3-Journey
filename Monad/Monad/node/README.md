# Monad Testnet Node (Docker)

A minimal, production-like example for running a Monad Testnet node using Docker Compose.  
This setup is fully configurable via environment variables.

---

## Quick Start

```bash
# Clone this repo or copy the folder
cd Monad/Monad/node

# Copy example env and adjust values if needed
cp .env.example .env

# Edit .env (ports, image, boot peers if needed)
nano .env

# Launch the node
docker compose up -d

---

### 🧩 Quickstart (Official Image)

If you just want to run a clean Monad Testnet node using the official Docker image, use the new **quickstart-compose.yaml** file:

```bash
git clone https://github.com/Asplana92/Web3-Journey.git
cd Web3-Journey/Monad/Monad/node
cp .env.example .env
docker compose -f quickstart-compose.yaml up -d


✅ This version uses the official monad-xyz/monad-bft image
🚫 No deprecated categoryxyz/* images
💡 Safe for Testnet or DevNet setups out of the box
