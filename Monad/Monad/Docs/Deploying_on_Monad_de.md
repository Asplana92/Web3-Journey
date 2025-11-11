🌐 [English](./Deploying_on_Monad.md) | [Русский](./Deploying_on_Monad_ru.md) | Română | [Deutsch](./Deploying_on_Monad_de.md) | [Norsk](./Deploying_on_Monad_no.md)



# Bereitstellung eines Monad-Knotens

> Aktualisierte Version des Handbuchs, die die neuesten Änderungen an Docker Compose und der Testnet-Konfiguration enthält.

Dieses Handbuch erklärt, wie man einen Monad-Knoten mit Docker bereitstellt.  
Es richtet sich an Entwickler, RPC-Betreiber und Community-Mitglieder, die dem Testnetz beitreten möchten.

---

## 1. Systemanforderungen

- Ubuntu 22.04 oder neuer  
- CPU mit mindestens 4 Kernen und 8 GB RAM  
- Docker + Docker Compose Plugin  
- Offene Ports: 26656 (P2P) und 26657 (RPC)

---

## 2. Docker installieren

```bash
sudo apt update && sudo apt install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

---

## 3. Konfiguration

Erstelle ein Arbeitsverzeichnis und eine `.env`-Datei:

```
MONAD_IMAGE=monadxyz/monad-node:latest
NETWORK=testnet
RPC_PORT=26657
P2P_PORT=26656
DATA_DIR=/opt/monad
```

---

## 4. Knoten starten

```bash
docker compose up -d
```

Überprüfe den Status des Knotens:

```bash
curl http://127.0.0.1:26657/status
```

Wenn die Ausgabe Blockinformationen enthält, läuft dein Knoten korrekt.

---

## 5. Überwachung und Wartung

- Integriere Prometheus + Grafana für Metriken  
- Füge einen systemd-Dienst zur automatischen Neustart hinzu  
- Aktualisiere regelmäßig das Docker-Image, um mit der Testnet-Version synchron zu bleiben

---

**Autor:** Tolik | Infra Builder  
Community-Beitrag zur Monad-Dokumentation


# Bereitstellung eines Monad-Knotens

> Aktualisierte Version des Handbuchs, die die neuesten Änderungen an Docker Compose und der Testnet-Konfiguration enthält.

Dieses Handbuch erklärt, wie man einen Monad-Knoten mit Docker bereitstellt.  
Es richtet sich an Entwickler, RPC-Betreiber und Community-Mitglieder, die dem Testnetz beitreten möchten.

---

## 1. Systemanforderungen

- Ubuntu 22.04 oder neuer  
- CPU mit mindestens 4 Kernen und 8 GB RAM  
- Docker + Docker Compose Plugin  
- Offene Ports: 26656 (P2P) und 26657 (RPC)

---

## 2. Docker installieren

```bash
sudo apt update && sudo apt install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

---

## 3. Konfiguration

Erstelle ein Arbeitsverzeichnis und eine `.env`-Datei:

```
MONAD_IMAGE=monadxyz/monad-node:latest
NETWORK=testnet
RPC_PORT=26657
P2P_PORT=26656
DATA_DIR=/opt/monad
```

---

## 4. Knoten starten

```bash
docker compose up -d
```

Überprüfe den Status des Knotens:

```bash
curl http://127.0.0.1:26657/status
```

Wenn die Ausgabe Blockinformationen enthält, läuft dein Knoten korrekt.

---

## 5. Überwachung und Wartung

- Integriere Prometheus + Grafana für Metriken  
- Füge einen systemd-Dienst zur automatischen Neustart hinzu  
- Aktualisiere regelmäßig das Docker-Image, um mit der Testnet-Version synchron zu bleiben

---

**Autor:** Tolik | Infra Builder  
Community-Beitrag zur Monad-Dokumentation
