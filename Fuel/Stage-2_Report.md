🔥 Fuel | Path to Rank S — Stage 2 Report
Title: Monitoring Stack Setup (Prometheus + Grafana)  
Status: ✅ Completed  
Date: 1 November 2025  

---

 🧩 1. Summary
After finishing Stage 1 (basic Fuel setup and infrastructure), this stage focused on adding a **monitoring layer** to observe the node, the host machine, and the Fuel RPC endpoint in real time.  
The goal was to reach an infrastructure level similar to the Monad monitoring stack previously deployed in this repository.

---

 ⚙️ 2. Setup Overview

Server: Ubuntu 24.04 LTS · 8 GB RAM · Hetzner  
Stack: Docker-based monitoring

Services/containers:
- `prometheus` — central metrics collection
- `grafana` — dashboards and visualization
- `node_exporter` — host-level metrics (CPU, RAM, filesystem)
- `cadvisor` — Docker/container metrics
- `blackbox_exporter` — HTTP checks for the Fuel RPC endpoint

Key points:
- Prometheus scrapes all exporters every 15 seconds.
- Grafana is configured to use Prometheus as the primary data source.
- A dedicated dashboard for Fuel was created and verified.
- The dashboard shows both system-level metrics and RPC-level metrics.

---

 📊 3. Metrics & Visualization

What we monitor now:
- Host metrics (Node Exporter):  
  - CPU usage  
  - Memory usage  
  - Disk/FS usage  
- Container metrics (cAdvisor):  
  - Running containers  
  - Resource usage per container  
- Fuel RPC health (Blackbox):  
  - HTTP status = 200 ✅  
  - Probe success = 1  
  - Latency: around 211 ms (stable)

Thresholds (Grafana):
- `< 300 ms` → green (OK)
- `300–800 ms` → yellow (warning)
- `> 800 ms` → red (critical)

---

 ✅ 4. Verification

- All Prometheus targets are UP
- Grafana dashboard is reachable and displays metrics
- Fuel RPC endpoint responds with HTTP 200
- Latency graph is updating in real time
- Network RX/TX graphs show normal polling activity from Prometheus

---

 🖼️ Dashboard Preview

Below is the live Grafana dashboard snapshot confirming that Fuel RPC latency is collected and visualized.

> 📸 Image path in repo: `Fuel/Screens/FuelGrafan.png`

```text
![FuelGrafan Dashboard](./Screens/FuelGrafan.png)


🚀 5. Next Steps

Add alerting rules in Grafana/Prometheus for:

Fuel RPC latency > 800 ms

Fuel RPC HTTP status != 200

Any exporter goes DOWN

Publish this Stage 2 report in Discord #share-projects and reference this GitHub file.

Reuse this monitoring stack for other Titan projects to keep the same style across the repo.

🏁 6. Outcome

Stage 2 brings the Fuel setup to a monitored and observable state.
This matches the style of the existing Monad monitoring work and continues the Path to Rank S documentation line in this repository.
