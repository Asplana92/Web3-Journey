# 🧠 Monad · Path to Rank S · Final Stage (Monitoring & Automation)

**Author:** asplana92  
**Date:** October 2025  
**Project:** Monad DevNet + Public RPC Infra  
**Goal:** Complete Path to Rank S through full infra + monitoring stack deployment.

---

## 🏗 Overview

This final stage concludes my Monad Path to Rank S journey — building, securing, and monitoring a full Monad DevNet and RPC infrastructure.  
All components now operate in automated mode with HTTPS, metrics collection, Grafana dashboards, and alerting logic in place.

---

## 🧩 Infrastructure Summary

| Component | Description | Status |
|------------|--------------|--------|
| **Node** | Single-node Monad DevNet running inside Docker | 🟢 Online |
| **RPC Proxy** | `monad.skandicescape.online` (HTTPS via Let’s Encrypt) | 🟢 Active |
| **Monitoring** | Prometheus + Grafana stack | 🟢 Operational |
| **Metrics Exporters** | Node Exporter (9100), NGINX Exporter (9113), Prometheus (9090) | 🟢 UP |
| **Health Automations** | Systemd timers + auto-restart scripts | 🟢 Enabled |
| **Security** | UFW · Fail2Ban · Unattended upgrades | 🟢 Configured |

---

## ⚙️ Monitoring Stack (Stage 6 + Final)

**Prometheus 3.7.2** collects metrics from:
- `node_exporter :9100`
- `nginx_prometheus_exporter :9113`
- `prometheus :9090` (self-scrape)

---

### 🧾 Launch Command (Corrected)
```bash
docker run -d --name prometheus --restart unless-stopped \
  --network host \
  -v /opt/monad-monitor/prometheus:/etc/prometheus:ro \
  prom/prometheus:latest \
  --config.file=/etc/prometheus/prometheus.yml


📊 Grafana Visualization

The following screenshot shows the final live Grafana dashboard for Monad monitoring:

Dashboard: asplana92 | Monad Node Metrics
Metrics Sources: Prometheus (node_exporter, nginx_exporter, self-scrape)
Uptime: 5.9 days (stable)

🧠 Alert Rules

Rules file: /etc/prometheus/alerts.yml

HighDiskUsage ⚠️ — triggers if disk usage > 85 % for 5 min

NginxHigh5xx 🚨 — triggers if 5xx rate > 1 req/s for 2 min

NodeDown 🛑 — auto-validated and tested locally

All rules health: ✅ OK

🗄️ Backups & Restoration

Backup archive:
/root/monad-monitor-backup-20251029-013910.tar.gz

Contents: 

/opt/monad-monitor/prometheus
/etc/grafana/grafana.ini

Exported dashboard JSON:
/root/monad-grafana-dashboard.json

Restoration:
Extract archive and rerun Prometheus & Grafana containers (reproducible under 2 min).

🚀 Results

100 % target uptime (monad-nginx, node, prometheus)

0 errors in Prometheus config check

Stable Grafana visualization and public access

Automated alerts tested locally (no false positives)

Secure and hardened Ubuntu 24.04 server on Hetzner (8 GB RAM)

🔭 Next Steps

Keep monitoring online for uptime reputation proof.

Publish summary on Discord #share-projects and Twitter.

Move to next Titan chain deployment.

Maintain Monad monitoring as a reference setup for builders.

🧩 Conclusion

Monad infrastructure stack is fully operational, documented and backed up.
This marks the official completion of the Monad Path to Rank S journey —
a fully automated, secure, and monitored infra ready for next-gen testnets.

— asplana92 | Web3 Infra Builder

💬 Commit Message

Title: Add Monad Stage Final Report (Monitoring & Automation)
Description:
Completed Monad Path to Rank S — Final Stage (Monitoring & Automation).

Detailed report covering Prometheus, Grafana, alerts, and backups.

Infrastructure verified: all targets UP, rules health OK.

Marks official completion of Monad Path to Rank S journey.


Add Monad Stage Final Report (Monitoring & Automation)

---

### 🌐 Connect

**Follow the journey:**  
[🐦 Twitter](https://twitter.com/02Tolik02) · [💬 Discord](https://discord.gg/monad) · [💻 GitHub](https://github.com/Asplana92)

> _Monad Path to Rank S — Completed October 2025_  
> _by asplana92 · Web3 Infra Builder_
