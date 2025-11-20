#!/usr/bin/env bash

RPC_URL="https://monad.skandicescape.online/rpc"
LOG_FILE="/tmp/monad_rpc_health.log"

timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

check_block() {
  curl -s -X POST "$RPC_URL" \
    -H "Content-Type: application/json" \
    -d '{"jsonrpc":"2.0","id":1,"method":"eth_blockNumber","params":[]}'
}

echo "===== $(timestamp) =====" >> "$LOG_FILE"
echo "[1] Checking eth_blockNumber..." >> "$LOG_FILE"

RESP1=$(check_block)
sleep 2
RESP2=$(check_block)

echo "[2] RESP1: $RESP1" >> "$LOG_FILE"
echo "[3] RESP2: $RESP2" >> "$LOG_FILE"


if [[ -z "$RESP1" ]]; then
  echo "RPC FAIL — no response from eth_blockNumber" | tee -a "$LOG_FILE"
  exit 1
fi


BLOCK1=$(echo "$RESP1" | sed -n 's/.*"result":"\([^"]*\)".*/\1/p')
BLOCK2=$(echo "$RESP2" | sed -n 's/.*"result":"\([^"]*\)".*/\1/p')

echo "[4] BLOCK1: $BLOCK1" >> "$LOG_FILE"
echo "[5] BLOCK2: $BLOCK2" >> "$LOG_FILE"

if [[ -z "$BLOCK1" || "$BLOCK1" == "null" ]]; then
  echo "RPC FAIL — invalid blockNumber response" | tee -a "$LOG_FILE"
  exit 1
fi

if [[ "$BLOCK1" == "$BLOCK2" ]]; then
  echo "RPC WARNING — blockNumber is not increasing (might be stalled)" | tee -a "$LOG_FILE"
  exit 0
else
  echo "RPC OK — blockNumber is increasing ✔" | tee -a "$LOG_FILE"
  exit 0
fi
