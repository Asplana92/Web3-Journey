🌐 [English](./Deploying_on_Monad.md) | [Русский](./Deploying_on_Monad_ru.md) | [Română](./Deploying_on_Monad_ro.md) | [Deutsch](./Deploying_on_Monad_de.md) | [Norsk](./Deploying_on_Monad_no.md)
---



# Implementarea unui nod Monad

> Versiunea actualizată a ghidului, care include cele mai recente modificări ale configurației Docker Compose și Testnet.

Acest ghid explică cum să implementezi un nod Monad folosind Docker.  
Este potrivit pentru dezvoltatori, operatori RPC și membri ai comunității care se alătură rețelei de testare.

---

## 1. Cerințe de sistem

- Ubuntu 22.04 sau o versiune mai nouă  
- CPU cu cel puțin 4 nuclee, 8 GB RAM  
- Docker + plugin Docker Compose  
- Porturi deschise: 26656 (p2p) și 26657 (RPC)

---

## 2. Instalarea Docker

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

## 3. Configurare

Creează un director de lucru și un fișier `.env`:

```
MONAD_IMAGE=monadxyz/monad-node:latest
NETWORK=testnet
RPC_PORT=26657
P2P_PORT=26656
DATA_DIR=/opt/monad
```

---

## 4. Pornirea nodului

```bash
docker compose up -d
```

Verifică statusul nodului:

```bash
curl http://127.0.0.1:26657/status
```

Dacă rezultatul returnează informații despre blocuri, nodul tău funcționează corect.

---

## 5. Monitorizare și mentenanță

- Integrează Prometheus + Grafana pentru metrici  
- Adaugă un serviciu systemd pentru repornire automată  
- Actualizează periodic imaginea Docker pentru a rămâne sincronizat cu versiunile Testnet

---

**Autor:** Tolik | Infra Builder  
Contribuție comunitară pentru documentația Monad
