# 🛠️ Fuel Path to Rank S — Stage 1 Report  
### ✅ Stage 1: RPC Infra + Autostart + Health Monitoring  
**Date:** October 30, 2025  
**Author:** asplana92 (Tolik)  
**Server:** Hetzner Ubuntu 24.04 (8 GB RAM)

---

## ⚙️ Setup Summary
- Installed and compiled **fuel-core v0.47.1** from source  
- Configured working directory `/root/.fuel`
- Node launched in testnet observer mode (`rocks-db`, `utxo-validation`)
- RPC port: `4000`, P2P port: `30333`
- Verified via `systemctl status fuel` — stable runtime under systemd
- Auto-restart enabled on failure

---

## 🧩 Systemd Units
### `fuel.service`
```ini
[Unit]
Description=Fuel Core Node
After=network.target

[Service]
User=root
WorkingDirectory=/root/.fuel
ExecStart=/usr/local/bin/fuel-core run \
  --ip 0.0.0.0 \
  --port 4000 \
  --peering-port 30333 \
  --db-type rocks-db \
  --db-path /root/.fuel/db \
  --utxo-validation
Restart=always
RestartSec=10
LimitNOFILE=65535
StandardOutput=append:/var/log/fuel.log
StandardError=append:/var/log/fuel.log

[Install]
WantedBy=multi-user.target
fuel-health.sh
#!/bin/bash
LOG=/var/log/fuel-health.log
TS=$(date '+%Y-%m-%d %H:%M:%S')
if curl -s http://127.0.0.1:4000/health | grep -q '"status":"OK"'; then
  echo "$TS ✅ Fuel node healthy" >> $LOG
else
  echo "$TS ⚠️ Fuel node unhealthy — restarting..." >> $LOG
  systemctl restart fuel
fi
fuel-health.timer

Runs every 5 minutes for continuous uptime monitoring.
📊 Monitoring

/var/log/fuel.log — runtime logs

/var/log/fuel-health.log — health-status records

Auto-healing tested successfully (⚠️ restart → ✅ healthy)

🌐 Next Steps — Stage 2

Deploy Prometheus + Grafana dashboards for metrics collection

Expose public read-only Grafana at grafana.skandicescape.online/fuel

Prepare Fuel Stage 2 Report & public update on Discord and Twitter

Tolik (asplana92)

“Consistency builds reputation — automation keeps it online.” 🚀
