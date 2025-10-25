# Investigation: categoryxyz/monad-* images fail to start

**Date:** 2025-10-25  
**Author:** Tolik (@Asplana92)  
**Context:** Monad Path to Rank S – Stage 2 (Infra Research)

---

## 🧩 Summary

While testing local Monad DevNet node deployment with Docker images from `categoryxyz/*`, all containers (`monad-execution`, `monad-rpc`) failed to start.

Logs show that these builds are **hard-coded for `CHAIN_CONFIG_ETHEREUM_MAINNET`** and crash instantly when run with `--chain monad_devnet`.

---

## 🔍 Steps Performed

1. Pulled the images:
   ```bash
   docker pull categoryxyz/monad-execution:latest
   docker pull categoryxyz/monad-rpc:latest
   
   Checked what binaries exist:
docker run --rm categoryxyz/monad-execution:latest sh -lc 'command -v monad'
→ Found /usr/local/bin/monad

Attempted to start:
docker run ... /usr/local/bin/monad --chain monad_devnet

Observed fatal crash:
Assertion 'chain_config == CHAIN_CONFIG_ETHEREUM_MAINNET' failed.


🧠 Analysis

These Docker images are non-functional for public use.

They only accept ethereum_mainnet mode and abort on others.

They are likely internal stubs or testing builds.

Public users should avoid them and use official monad-xyz/ images instead.

✅ Resolution

Removed all categoryxyz/* containers and volumes.

Continued development using the official Monad Testnet RPC via monad-proxy.service.

Proceeding to Stage 2: Prometheus + Grafana monitoring stack setup.

💬 Impact

This finding saves time for others and contributes valuable infra research to Monad community and OpenBuild Rank S initiative.

Tags: Monad DevNet, Docker, Infra Testing, categoryxyz, Rank S Progress
