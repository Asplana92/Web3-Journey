🧭 Monad Path to Rank S
Stage 1 — From Scratch to Self-Healing RPC

By @02Tolik02 | Asplana92
documenting my Web3 Infra Builder journey on Monad OpenBuild
⚙️ Stage 1 — Setting the Foundation

🖥 Server: Hetzner · 8 GB RAM · Ubuntu 24.04 LTS
🌐 Domain: monad.skandicescape.online

🎯 Goal: Deploy a secure, public RPC endpoint for Monad Testnet
with HTTPS, reliability & automation.

🧱 Infrastructure Baseline
| Component    | Description                                           | Status |
| ------------ | ----------------------------------------------------- | ------ |
| **OS**       | Ubuntu 24.04 LTS (clean install)                      | ✅      |
| **Firewall** | `ufw` (80/443 open)                                   | ✅      |
| **Security** | Fail2Ban + auto updates                               | ✅      |
| **Network**  | Static IP → DNS A-record → monad.skandicescape.online | ✅      |
| **Packages** | nginx · docker · certbot                              | ✅      |


🔐 Nginx Reverse Proxy + SSL

Proxy forwards HTTPS → local RPC on 127.0.0.1:8080
and shows a friendly message for browsers.

server {
    listen 443 ssl;
    server_name monad.skandicescape.online;

    ssl_certificate     /etc/letsencrypt/live/monad.skandicescape.online/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/monad.skandicescape.online/privkey.pem;

    # Browser-friendly text
    location = / {
        add_header Content-Type text/plain;
        return 200 'Monad JSON-RPC endpoint. Use POST to /rpc with application/json.';
    }

    # Actual RPC endpoint
    location /rpc {
        proxy_pass http://127.0.0.1:8080/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_read_timeout 300s;
    }
}

server {
    listen 80;
    server_name monad.skandicescape.online;
    return 301 https://$host$request_uri;
}

✅ Verification Logs

# 1️⃣ Test GET
curl -sS https://monad.skandicescape.online/
→ Monad JSON-RPC endpoint. Use POST to /rpc with application/json.

# 2️⃣ Test POST
curl -sS https://monad.skandicescape.online/rpc \
  -H 'content-type: application/json' \
  --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":1}'
→ {"jsonrpc":"2.0","result":"Monad/82909b1","id":1}

# 3️⃣ DNS check
dig +short monad.skandicescape.online
→ <server-IP-hidden-for-security>
📡 RPC successfully connected to Monad Testnet.
MetaMask + Foundry tested → working perfectly.



🛠 Stage 2 — Automation & Reliability

Added self-healing monitoring with systemd + Bash.
🩺 /usr/local/bin/monad-health.sh

#!/bin/bash
URL="https://monad.skandicescape.online/rpc"
LOG="/var/log/monad-health.log"
TS=$(date '+%F %T')
RES=$(curl -sS --max-time 10 -H 'content-type: application/json' \
  --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":1}' \
  "$URL" | grep -o '"result"')

if [[ "$RES" == '"result"' ]]; then
  echo "$TS OK: RPC responding." >> "$LOG"
else
  echo "$TS FAIL: RPC unresponsive. Restarting proxy..." >> "$LOG"
  systemctl restart monad-proxy.service
fi

⏱ Systemd Timer

# /etc/systemd/system/monad-health.service
[Unit]
Description=Monad RPC Health Check
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/monad-health.sh
# /etc/systemd/system/monad-health.timer
[Unit]
Description=Run Monad RPC health check every 5 minutes

[Timer]
OnBootSec=2min
OnUnitActiveSec=5min
Unit=monad-health.service

[Install]
WantedBy=timers.target


Enable & verify:
sudo systemctl daemon-reload
sudo systemctl enable --now monad-health.timer
systemctl list-timers --all | grep monad-health
✅ Result: automatic 5-minute health check + auto-restart if RPC fails.

🧩 Stack Summary
| Component               | Purpose                       | Status     |
| ----------------------- | ----------------------------- | ---------- |
| **monad-proxy.service** | HTTPS RPC proxy (Nginx)       | 🟢 Active  |
| **monad-health.sh**     | Health-check script           | 🟢 OK      |
| **monad-health.timer**  | Automation (5 min)            | 🟢 Running |
| **Security**            | UFW · Fail2Ban · Auto updates | ✅ Enabled  |


🌐 Public RPC
https://monad.skandicescape.online/rpc
Use with Foundry:
cast block-number --rpc-url https://monad.skandicescape.online/rpc


🧠 Why It Matters for Rank S

This setup represents:

Infrastructure reliability — stable, SSL-secured RPC.

Automation — self-monitoring & auto-healing system.

Community value — public endpoint for Monad developers.

Building not only for uptime, but for trust.
Next stage → metrics dashboard (Grafana + Prometheus).



---

📄 **Stage Reports**
- [Stage 1 Report → Secure RPC Deployment](./Stage-1_Report.md)
- *(Upcoming)* Stage 2 → Automation & Monitoring (Grafana + Prometheus)

---

### 🧭 Progress Roadmap

- ✅ [Stage 1 — RPC & Automation Setup](./Stage-1_Report.md)
- 🚀 [Stage 2 — Monitoring & Infra Reliability](./Stage-2_Report.md)
- 🔜 Stage 3 — Public Dashboards + Validator Simulations







added Monad Path to Rank S — secure RPC and health automation


