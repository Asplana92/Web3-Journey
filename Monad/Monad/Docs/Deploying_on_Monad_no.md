🌐 [English](./Deploying_on_Monad.md) | [Русский](./Deploying_on_Monad_ru.md) | [Română](./Deploying_on_Monad_ro.md) | [Deutsch](./Deploying_on_Monad_de.md) | [Norsk](./Deploying_on_Monad_no.md)
---




# Distribuering av en Monad-node

> Oppdatert versjon av veiledningen som inkluderer de siste endringene i Docker Compose og Testnet-konfigurasjonen.

Denne guiden forklarer hvordan du distribuerer en Monad-node ved hjelp av Docker.  
Den er ment for utviklere, RPC-operatører og fellesskapsmedlemmer som blir med i testnettet.

---

## 1. Systemkrav

- Ubuntu 22.04 eller nyere  
- CPU med minst 4 kjerner og 8 GB RAM  
- Docker + Docker Compose-plugin  
- Åpne porter: 26656 (p2p) og 26657 (RPC)

---

## 2. Installer Docker

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

## 3. Konfigurasjon

Lag en arbeidsmappe og en `.env`-fil:

```
MONAD_IMAGE=monadxyz/monad-node:latest
NETWORK=testnet
RPC_PORT=26657
P2P_PORT=26656
DATA_DIR=/opt/monad
```

---

## 4. Start noden

```bash
docker compose up -d
```

Sjekk statusen til noden:

```bash
curl http://127.0.0.1:26657/status
```

Hvis resultatet viser blokkdata, fungerer noden som den skal.

---

## 5. Overvåking og vedlikehold

- Integrer Prometheus + Grafana for målinger  
- Legg til en systemd-tjeneste for automatisk omstart  
- Oppdater Docker-bildet regelmessig for å holde deg synkronisert med testnettet

---

**Forfatter:** Tolik | Infra Builder  
Fellesskapsbidrag til Monad-dokumentasjonen
