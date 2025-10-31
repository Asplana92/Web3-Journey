   ⚙️ Fuel Path to Rank S — Report

   ✅ Stage 1: RPC Infra + Autostart + Health Monitoring

**Date:** October 31, 2025  
**Author:** asplana92 (Tolik)  
**Server:** Hetzner, Ubuntu 24.04 (8 GB RAM)

---

1. Setup Summary

- Installed and compiled **fuel-core v0.47.1** from source.  
- Working directory: **`/root/.fuel`**  
- Node launched in **testnet observer mode**:
  - `--db-type rocks-db`
  - `--utxo-validation`
  - P2P open  
- RPC port: **4000**, P2P port: **30333**  
- Managed by **systemd** (`fuel.service`)  
- **Auto-restart** on failure  
- **Health check** every 5 minutes (`fuel-health.service` + `fuel-health.timer`)  
- Logs written to `/var/log/fuel.log` and `/var/log/fuel-health.log`

---

2. Systemd Units

2.1 `fuel.service`

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

2.2 fuel-health.sh

#!/bin/bash
LOG=/var/log/fuel-health.log
TS=$(date '+%Y-%m-%d %H:%M:%S')

if curl -s http://127.0.0.1:4000/health | grep -q '"status":"OK"'; then
  echo "$TS ✅ Fuel node healthy" >> "$LOG"
else
  echo "$TS ⚠️ Fuel node unhealthy — restarting..." >> "$LOG"
  systemctl restart fuel
fi
chmod +x /usr/local/bin/fuel-health.sh

2.3 fuel-health.service

[Unit]
Description=Fuel node health check

[Service]
Type=oneshot
ExecStart=/usr/local/bin/fuel-health.sh

2.4 fuel-health.timer

[Unit]
Description=Run Fuel health check every 5 minutes

[Timer]
OnBootSec=2min
OnUnitActiveSec=5min
Unit=fuel-health.service

[Install]
WantedBy=timers.target
systemctl daemon-reload
systemctl enable --now fuel.service
systemctl enable --now fuel-health.timer
systemctl status fuel
systemctl status fuel-health.timer
tail -f /var/log/fuel-health.log

3. Monitoring

Runtime logs: /var/log/fuel.log

Health logs: /var/log/fuel-health.log

Auto-healing tested: ❗ unhealthy → ✅ restart → ✅ healthy

4. Next Steps — Stage 2

Deploy Prometheus + Grafana to collect Fuel node metrics.

Expose read-only Grafana at grafana.skandicescape.online/fuel.

Publish Fuel Stage-2 Report → GitHub → Discord → X.

Keep uptime high — consistency = reputation.

Tolik (asplana92)
“Consistency builds reputation — automation keeps it online.” 🚀
