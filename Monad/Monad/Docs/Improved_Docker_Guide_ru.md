🌐 [English](Improved_Docker_Guide.md) | [Русский](Improved_Docker_Guide_ru.md) | [Deutsch](Improved_Docker_Guide_de.md)


# 📘 Улучшенное руководство по Docker для одной ноды Monad

Упрощённая и надёжная в продакшене установка для запуска однонодового окружения Monad через Docker.  
Включает переменные окружения `.env`, файл `docker-compose.yml`, health-check, логи, метрики (готово для Prometheus/Grafana) и советы по устранению неполадок.

---

## 1️⃣ Обзор

Это руководство поможет быстро и чисто развернуть одну ноду Monad.  
Можно использовать как для **DevNet**, так и для **Testnet** (меняя значения в переменных).

---

## 2️⃣ Предварительные требования

- Ubuntu 22.04+ (или любой современный Linux)  
- Docker + Docker Compose plugin  
- Пользователь без root, имеющий sudo, либо запуск под root  
- Открытые порты:
  - `26656` (p2p)
  - `26657` (RPC)
  - `8545` (HTTP RPC, если включено)
  - `9100/9113/9090/3000` (для мониторинга, опционально)

---

### Установка Docker (если не установлен)

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


3️⃣ Структура каталогов

/opt/monad
├─ .env
├─ docker-compose.yml
└─ data/

Создайте структуру:
sudo mkdir -p /opt/monad/data
cd /opt/monad

4️⃣ Пример .env.example

NETWORK=testnet
P2P_PORT=26656
RPC_PORT=26657
HTTP_RPC_PORT=8545
PUBLIC_ADDR=
DATA_DIR=/opt/monad/data
MONAD_IMAGE=monadxyz/monad-bft:latest
BOOT_PEERS=
ENABLE_METRICS=true

Скопируйте и отредактируйте:
cp .env.example .env
nano .env

5️⃣ Пример docker-compose.yml

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
      
6️⃣ Управление: запуск, остановка, логи
docker compose up -d
docker ps
docker logs -f monad
docker compose down

7️⃣ Проверка статуса
curl -s http://127.0.0.1:${RPC_PORT}/status | jq
ss -ltnp | grep ${P2P_PORT}
curl -s http://127.0.0.1:${HTTP_RPC_PORT}/ | head


```markdown
## 8) Мониторинг

Запустите **Prometheus**, **Grafana** и **Node Exporter**,  
чтобы получить полную видимость и метрики работы ноды Monad.

---

## 9) Безопасность

- Не открывайте RPC с правом записи в публичную сеть.  
- Используйте HTTPS-reverse-proxy (например, **nginx** или **Caddy**).  
- Включите **firewall (ufw)** и вход по **SSH-ключу**.

---

## 📝 Благодарности

Адаптировано из официального Docker-репозитория  
**monad-xyz/monad-bft**  
для удобного развертывания ноды Monad и использования сообществом.
```
