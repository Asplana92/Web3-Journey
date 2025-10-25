# 🧠 Monad Path to Rank S — Stage 2 Report

**Author:** Tolik (@Asplana92)  
**Date Started:** 2025-10-25  
**Focus:** Monitoring + Infrastructure Reliability  

---

## 1️⃣ Research Findings

### 🧩 Issue: `categoryxyz/monad-*` Docker images crash on devnet

While testing local Monad DevNet node deployment, I discovered that the `categoryxyz/monad-execution` and `categoryxyz/monad-rpc` images fail to start.

Error log:
Assertion 'chain_config == CHAIN_CONFIG_ETHEREUM_MAINNET' failed.

🧠 Analysis and resolution →  
[Detailed report on GitHub › Monad/Reports/2025-10-25_Categoryxyz_Images_Issue.md](./Reports/2025-10-25_Categoryxyz_Images_Issue.md)

---

## 2️⃣ Monitoring Stack Setup (in progress)

Goal: implement a **Prometheus + Grafana** stack for live health metrics of:
- monad-proxy.service (RPC availability)
- monad-health.timer (systemd uptime)
- Docker containers (memory/CPU)
- Nginx SSL endpoints

✅ Planned deliverables:
- Docker Compose configuration for Prometheus & Grafana  
- Dashboards + alerts for uptime and request latency  
- Public screenshot for report Stage 2 completion

---

## 3️⃣ Notes & Next Steps

- Prepare dashboard JSON export for GitHub repo.  
- Share Stage 2 completion post on Discord + Twitter once monitoring stack is verified.  

---

**#Monad #OpenBuild #RankS #DevOps #Asplana92**
