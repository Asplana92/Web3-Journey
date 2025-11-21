# 🧱 Monad Infrastructure & Builder Journey

**Author:** Tolik (Asplana92)  
**Role:** Independent Infrastructure & DevOps Builder  
**Focus:** RPC reliability, monitoring, tooling, documentation  
**Ecosystem:** Monad, Fuel, Initia, Celestia, Berachain, Aleo, Dymension, Saga

This directory contains my full Monad infrastructure journey, including testnet work, tools, monitoring dashboards, reports, and contributions aimed at improving the ecosystem and earning long-term Builder Rewards.

---

# 🚀 Current Infrastructure

### **🔹 Public RPC Endpoint**
A stable and fully monitored public Testnet RPC: https://monad.skandicescape.online



### **🔹 Public Grafana Dashboard**
Live node & RPC monitoring dashboard:https://grafana.skandicescape.online


Features:
- RPC latency tracking  
- Block progression monitoring  
- Node resource metrics  
- Automated alerts (Prometheus + Alertmanager + Discord)  
- Uptime monitoring  

---

# 🛠️ Tools

### **1️⃣ Monad RPC Health Checker Script**
A lightweight shell-based RPC diagnostic tool:  
➡️ **`tools/monad-rpc-health.sh`**

Features:
- Checks `eth_blockNumber`
- Confirms block progression
- Logs all results to `/tmp`
- Detects RPC stalls or downtime
- Useful for infra builders & DevOps automation

README:  
`/Monad/tools/README.md`

---

# 📘 Reports & Documentation

### ✔ Stage 1: RPC Infrastructure  
`Monad/Stage-1_Report.md`

### ✔ Stage 2: Monitoring Automation  
`Monad/Stage-2_Report.md`

### ✔ Stage Final: Production Monitoring (Grafana, Prometheus, Alertmanager)  
`Monad/Reports/Stage-Final_Report.md`

### ✔ Mainnet Preparation Checklist (Community Guide)
**New:**  
`Monad/Reports/Mainnet_Preparation_Checklist.md`

A complete community-friendly checklist for the Monad Mainnet launch:
- Wallet safety  
- Network setup  
- Bridge readiness  
- Launch-day strategy  
- Troubleshooting  
- Safety reminders  
- Developer & trader guidance  

---

# 📌 Why This Work Matters

This repository demonstrates consistent, real infrastructure contribution:

### 🔧 Technical Value
- Real RPC hosting with uptime  
- Observability stack (Grafana, Prometheus, exporters)  
- Custom tools for the ecosystem  
- Security & operations documentation  
- Testnet troubleshooting and debugging  
- Automation pipelines  

### 💡 Community Value
- Guides  
- Reports  
- Clear setup instructions  
- Tools others can reuse  
- Public dashboards  

### 🏆 Contribution Value (OpenBuild)
This work contributes directly to:

- Builder Rewards  
- OpenBuild Rank progression (C → B → A → S)  
- Post-mainnet contribution programs  
- Ecosystem recognition  

---

# 🧭 Roadmap

### **🟩 Completed**
- RPC deployment + SSL  
- Monitoring stack  
- Testnet debugging  
- RPC tool creation  
- Mainnet checklist  
- Docs & reports  
- GitHub cleanup & structure  

### **🟧 Upcoming**
- JSON-RPC benchmarking tool  
- Load testing suite  
- Extended validator & node monitoring  
- Ecosystem integration dashboards  
- More public tooling for Mono ecosystem  

---

# 🤝 Feedback & Collaboration

If you'd like to collaborate, review, or reuse anything from this repo:

- Open an Issue  
- Submit suggestions  
- Contact via Discord (Tolik)  
- Follow the GitHub profile:  
  https://github.com/Asplana92

---

# ⭐ Support

If this work is useful — **star the repo**:  
https://github.com/Asplana92/Web3-Journey

This helps visibility and supports Builder Rank growth.

---

**Last Updated:** November 22, 2025  
**Status:** Pre-Mainnet (Testnet → Mainnet transition phase)


