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

