# 🧱 Monad DevNet / Testnet Progress Report  
**Author:** Tolik (@Asplana92)  
**Date:** October 24, 2025  
**Project:** Monad — part of Titan Infra Strategy  

---

## 🧠 Overview  
This report documents my progress with the **Monad DevNet** and the transition to the **official Monad Testnet**.  
The main focus: exploring node infrastructure, debugging Docker-based setup, and verifying the Testnet RPC layer.  

---

## 🧩 Environment  
- **Server:** Hetzner Cloud (8 GB RAM, Ubuntu 24.04 LTS)  
- **Local system:** macOS (Apple Silicon)  
- **Tools used:** Docker, Docker Compose, Nginx, Foundry (`cast`), MetaMask  

---

## ⚙️ Actions Performed  

### 1. DevNet setup and debugging  
- Built local single-node DevNet from Docker images.  
- Faced issues with `categoryxyz/monad-*` builds (missing binaries, no entrypoint).  
- Containers `monad_execution` and `monad_rpc` were constantly restarting.  
- Repositories `categoryxyz/monad-bft` and `monad-xyz/monad-bft` returned **404** errors.  

### 2. Environment cleanup  
- Fully removed old volumes, networks, and containers.  
- Created clean `/monad` structure:  

/monad/config
/monad/ledger
/monad/wal
/monad/triedb
/monad/ipc

- Prepared base compose configuration for execution + rpc components.  

### 3. Switch to official public Testnet  
Moved from DevNet containers to the **public Monad Testnet** with the following details:  

- Prepared base compose configuration for execution + rpc components. 

Network: Monad Testnet
Chain ID: 10143
RPC URL: https://testnet-rpc.monad.xyz/

Block Explorer: https://testnet.monadexplorer.com/

Symbol: MON 


### 4. Wallet connection  
- Connected **MetaMask** with address:  
  `0x6aEEC5699b016A68A82B0e4313141B69109b7bAf`  
- Requested test tokens via **OpenBuild Faucet** → waiting for claim cooldown.  
- Verified RPC responsiveness:  
  - `web3_clientVersion` → OK  
  - `eth_blockNumber` → OK  

---

## 📊 Current Status  
✅ Connected to official Monad Testnet  
✅ RPC working and responding  
⏳ Faucet cooldown active (awaiting MON tokens)  
🧱 Preparing next-stage full node setup using stable monad-xyz builds  

---

## 🚀 Next Steps  
- Deploy a clean, stable single-node setup from verified monad-xyz builds  
- Implement systemd auto-restart & Nginx HTTPS reverse proxy  
- Record metrics (sync speed, resource usage, RPC latency)  
- Document future updates and validator/faucet integration  

---

## 🔗 References  
- [Monad Explorer](https://testnet.monadexplorer.com)  
- [Monad Faucet – OpenBuild](https://faucet.openbuild.xyz/monad)  
- [GitHub Repo – Asplana92/monad-node-asplana92](https://github.com/Asplana92/monad-node-asplana92)  
- [Twitter – @02Tolik02](https://twitter.com/02Tolik02)  

---

### 🧩 Summary  
This phase focused on **debugging, environment hygiene, and RPC verification**.  
The next phase will include a clean node deployment and performance tracking for long-term uptime.

---


