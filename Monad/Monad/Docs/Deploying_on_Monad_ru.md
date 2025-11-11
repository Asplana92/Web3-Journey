# Развёртывание ноды Monad

В этом руководстве объясняется, как развернуть ноду Monad с использованием Docker.  
Подходит для разработчиков, операторов RPC и участников сообщества, присоединяющихся к тестовой сети.

---

## 1. Системные требования

- Ubuntu 22.04 или новее  
- 4+ ядра CPU, 8 ГБ RAM  
- Docker + плагин Docker Compose  
- Открытые порты 26656 (p2p) и 26657 (RPC)

---

## 2. Установка Docker

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

## 3. Конфигурация

Создайте рабочий каталог и файл `.env`:

```
MONAD_IMAGE=monadxyz/monad-node:latest
NETWORK=testnet
RPC_PORT=26657
P2P_PORT=26656
DATA_DIR=/opt/monad
```

---

## 4. Запуск ноды

```bash
docker compose up -d
```

Проверка состояния ноды:

```bash
curl http://127.0.0.1:26657/status
```

Если команда возвращает информацию о блоках, нода успешно запущена.

---

## 5. Мониторинг и обслуживание

- Интегрируйте Prometheus + Grafana для метрик  
- Добавьте systemd unit для авто-рестарта  
- Регулярно обновляйте Docker-образ, чтобы оставаться синхронизированным с релизами Testnet

---

**Автор:** Tolik | Infra Builder  
Community contribution for Monad documentation
