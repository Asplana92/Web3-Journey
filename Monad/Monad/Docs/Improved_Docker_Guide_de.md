🌐 [English](Improved_Docker_Guide.md) | [Русский](Improved_Docker_Guide_ru.md) | [Deutsch](Improved_Docker_Guide_de.md)

# Verbesserte Docker-Anleitung für einen einzelnen Monad-Knoten

Vereinfachte, produktionssichere Konfiguration zum Ausführen einer einzelnen Monad-Node mit Docker.  
Beinhaltet `.env`-Variablen, `docker-compose.yml`, Health-Checks, Logs, Metriken (bereit für Prometheus/Grafana) und Tipps zur Fehlerbehebung.

---

## 1) Übersicht

Dieses Handbuch hilft dir, schnell und sauber einen einzelnen Monad-Knoten zu starten.  
Du kannst es sowohl für **DevNet** als auch für **Testnet** verwenden (Variablen anpassen).

---

## 2) Voraussetzungen

- **Ubuntu 22.04+** (oder jede aktuelle Linux-Distribution)  
- **Docker** + **Docker-Compose-Plugin**  
- Benutzer mit `sudo`-Rechten oder Root-Zugang  

**Offene Ports (Beispiel):**  
`26656` (p2p), `26657` (RPC), `8545` (HTTP-RPC, falls aktiviert),  
`9100/9113/9090/3000` — für Monitoring-Stack (optional)

---

### Docker installieren (falls noch nicht vorhanden)
```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

3) Verzeichnisstruktur
/opt/monad
├─ .env
├─ docker-compose.yml
└─ data/
Erstellen:
sudo mkdir -p /opt/monad/data
cd /opt/monad

4) Beispiel .env
NETWORK=testnet
P2P_PORT=26656
RPC_PORT=26657
HTTP_RPC_PORT=8545
PUBLIC_ADDR=
DATA_DIR=/opt/monad/data
MONAD_IMAGE=monadxyz/monad-bft:latest
BOOT_PEERS=
ENABLE_METRICS=true

Kopieren und bearbeiten:
cp .env.example .env
nano .env

5) Beispiel docker-compose.yml

version: "3.8"
services:
  monad:
    container_name: monad
    image: ${MONAD_IMAGE}
    restart: unless-stopped
    env_file:
      - .env
    command: >
      monad
      --network ${NETWORK}
      --p2p.laddr tcp://0.0.0.0:${P2P_PORT}
      --rpc.laddr tcp://0.0.0.0:${RPC_PORT}
      --rpc.http.addr 0.0.0.0:${HTTP_RPC_PORT}
      --p2p.seeds ${BOOT_PEERS}
      --moniker ${PUBLIC_ADDR}
    volumes:
      - ${DATA_DIR}:/var/lib/monad
    ports:
      - "${P2P_PORT}:${P2P_PORT}/tcp"
      - "${RPC_PORT}:${RPC_PORT}/tcp"
      - "${HTTP_RPC_PORT}:${HTTP_RPC_PORT}/tcp"
    healthcheck:
      test: ["CMD", "curl", "-fsS", "http://127.0.0.1:${RPC_PORT}/status"]
      interval: 30s
      timeout: 5s
      retries: 10

6) Start / Stopp / Logs
docker compose up -d
docker ps
docker logs -f monad
docker compose down

7) Überprüfung
curl -s http://127.0.0.1:${RPC_PORT}/status | jq
ss -ltnp | grep ${P2P_PORT}
curl -s http://127.0.0.1:${HTTP_RPC_PORT}/ | head


8) Monitoring

Starte Prometheus, Grafana und Node Exporter für vollständige Sichtbarkeit.

9) Sicherheit

RPC-Schreibmethoden nicht öffentlich zugänglich machen.

HTTPS-Reverse-Proxy (nginx / Caddy) verwenden.

Firewall (UFW) aktivieren und SSH-Zugang nur über Schlüssel erlauben.

Danksagung

Angepasst aus dem offiziellen monad-xyz/monad-bft-Repository
für vereinfachten Node-Betrieb und Community-Nutzung.
