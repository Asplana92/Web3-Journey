# Gonka Network Deployment Report - Stage 1: Setup & Investigation

**Author:** Asplana92  
**Date:** November 14, 2025  
**Status:** 🔴 Blocked - Awaiting Docker image fix  
**Related Issue:** [#431](https://github.com/gonka-ai/gonka/issues/431)

---

## 🎯 Project Goal

Deploy a complete Gonka Network infrastructure:
- **Inference Node** (Vast.ai) - GPU workloads
- **Chain Node** (Hetzner) - Blockchain validator
- **Integration** - Both working together

---

## 🏗️ Architecture Overview
```
┌─────────────────┐         ┌──────────────────┐
│   Vast.ai GPU   │────────▶│  Hetzner Chain   │
│ (Inference Node)│         │  (Validator Node)│
│   RTX 4090      │         │   Ubuntu 22.04   │
└─────────────────┘         └──────────────────┘
      ✅ Ready                    🔴 BLOCKED
```

**Current Bottleneck:** Chain Node cannot sync → blocks entire setup

---

## 📋 Part 1: Vast.ai Inference Node Setup

### 1.1 GPU Instance Configuration ✅
```
Provider: Vast.ai
GPU: RTX 4090
RAM: 32GB
Storage: 100GB NVMe
```

### 1.2 Setup Steps Completed ✅
- ✅ Instance rented and provisioned
- ✅ Docker environment configured
- ✅ Inference model prepared
- ✅ Network connectivity tested

### 1.3 Status
**Ready to connect** - Waiting for Hetzner Chain Node to sync

---

## 📋 Part 2: Hetzner Chain Node Setup

### 2.1 Server Configuration ✅
```
Provider: Hetzner Cloud
Server: Ubuntu 22.04 LTS
RAM: 8GB
CPU: 2 vCPU
Location: Helsinki, Finland
Public IP: xxx.xxx.xxx.xxx


```

### 2.2 Initial Setup ✅
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Clone repository
git clone https://github.com/gonka-ai/gonka.git
cd gonka/deploy/join

# Configure environment
cat > config.env << 'EOF'
ACCOUNT_NAME=Asplana92-Norway-4090
ACCOUNT_PASSWORD=<xxx.xxx.xxx.xxx>
SEED_NODE_URL=http://node2.gonka.ai:26657
SEED_NODE_RPC_URL=http://node2.gonka.ai:26657
SEED_NODE_P2P_URL=tcp://node2.gonka.ai:5000
DAPI_API__PUBLIC_URL=http://xxx.xxx.xxx.xxx:19250
EOF
```

### 2.3 Configuration ✅
- ✅ Created `priv_validator_state.json`
- ✅ Downloaded genesis from GitHub
- ✅ Configured persistent peers
- ✅ Opened firewall ports (26657, 5000)

### 2.4 Launch Attempt ❌
```bash
docker compose up -d
```

**Result:** Node stuck at height 1, cannot sync

---

## 🚨 Critical Bug Discovered

### Issue #1: AppHash Mismatch
```
Expected (Docker image): 91B9DFB33D5CA24E9187551295120008BDBB6B8B3A458BF02EACB32B19EC3FDF
Network uses:            9A3FAFD33F4694FD906B41860C6D3AE1DA5DA8F6F6A8C58BE56CFABBD8384E13
```

**Error Log:**
```
ERR Error in validation err="wrong Block.Header.AppHash. 
Expected 91B9DFB..., got 9A3FAFD..."
ERR Stopping peer for error err="reactor validation error"
```

**Diagnosis:** Docker image `inferenced:0.2.4` contains hard-coded outdated genesis

---

### Issue #2: Expired Trust Period
```
old header has expired at 2025-08-29 08:42:00
Current date: 2025-11-13 (77 days later)
```

**Error Log:**
```
ERR Can't verify err="verify from #1 to #1274001 failed: 
old header has expired at 2025-08-29..."
INF Snapshot rejected height=1274000
```

**Diagnosis:** State Sync cannot work with such old trust height

---

## 🔍 Troubleshooting Attempts (6+ hours)

### Attempt 1: Manual Genesis Download
```bash
curl -L https://raw.githubusercontent.com/gonka-ai/gonka/main/genesis/genesis.json \
  -o .inference/config/genesis.json
```
**Result:** ❌ Image still uses internal genesis

### Attempt 2: State Sync with Trust Hash
```bash
TRUST_HASH="9A3FAFD33F4694FD906B41860C6D3AE1DA5DA8F6F6A8C58BE56CFABBD8384E13"
sed -i "s/^trust_hash = .*/trust_hash = \"$TRUST_HASH\"/" config.toml
```
**Result:** ❌ Trust hash mismatch

### Attempt 3: Disable State Sync
```bash
sed -i 's/^enable = true/enable = false/' config.toml
```
**Result:** ❌ Back to AppHash mismatch

### Attempt 4: Multiple Trust Heights Tested
- Height 1 → Expired
- Height 1270000 → Expired
- Height from network → Mismatch

**Result:** ❌ All attempts failed

---

## 📊 Current Status

### Vast.ai Inference Node
```
✅ GPU instance: Running
✅ Docker: Configured
✅ Model: Ready
🟡 Status: Idle (waiting for Chain Node)
```

### Hetzner Chain Node
```
✅ Docker containers: Running
✅ P2P connections: 11+ peers connected
✅ RPC endpoint: Responding on :26657
✅ Configuration: Correct
❌ Sync status: Stuck at height 1
❌ Block sync: Fails with AppHash validation
❌ State sync: Fails with expired headers
```

### Overall Project Status
```
🔴 BLOCKED - Cannot proceed until Chain Node syncs
```

---

## 🎯 Root Cause Analysis

**Primary Issue:** Docker image `inferenced:0.2.4` contains hard-coded genesis from **August 29, 2025**

**Impact Chain:**
1. Chain Node cannot sync (AppHash mismatch)
2. Inference Node cannot connect (no working Chain Node)
3. **Entire Gonka deployment blocked**

**Severity:** 🔴 **CRITICAL** - Blocks all new node operators

---

## 📝 Issue Reported

**GitHub Issue:** [#431 - Docker image inferenced:0.2.4 incompatible with mainnet](https://github.com/gonka-ai/gonka/issues/431)

**Requested Solution:**
1. Updated Docker image with current genesis
2. OR working snapshot URL
3. OR manual genesis update instructions

---

## 📚 Lessons Learned

1. ✅ **Dual-server architecture** planned correctly
2. ✅ **Vast.ai GPU setup** successful and ready
3. ✅ **Hetzner infrastructure** configured properly
4. ✅ **Network connectivity** verified (11+ peers)
5. ⚠️ **Image versioning critical** - hard-coded genesis blocks deployment
6. ⚠️ **Trust period matters** - 77+ day gap breaks state sync
7. 💡 **Testing both components** revealed the blocker early

---

## ⏳ What's Next: Stage 2 Preview

Once the Docker image is fixed, Stage 2 will document:

### Hetzner Chain Node (Resume)
- [ ] Update to fixed Docker image
- [ ] Verify sync starts successfully
- [ ] Monitor sync progress to current height
- [ ] Confirm RPC/P2P endpoints working

### Vast.ai Integration (Final Step)
- [ ] Configure Inference Node to connect to Chain Node
- [ ] Test GPU workload execution
- [ ] Verify end-to-end workflow
- [ ] Performance benchmarking

### System Validation
- [ ] Full integration test
- [ ] Monitoring setup
- [ ] Documentation of final configuration

**Expected Timeline:** TBD (depends on Gonka team response)

---

## 📅 Timeline

| Date | Event |
|------|-------|
| Nov 11, 2025 | Vast.ai GPU instance rented ✅ |
| Nov 12, 2025 | Hetzner Chain Node setup ✅ |
| Nov 13, 2025 | AppHash mismatch discovered ❌ |
| Nov 13, 2025 | 12+ hours troubleshooting |
| Nov 13, 2025 | Root cause identified |
| Nov 13, 2025 | Issue #431 created |
| Nov 13, 2025 | **Stage 1 complete - Waiting for fix** |
| **TBD** | **Docker image fixed** |
| **TBD** | **Stage 2: Full deployment** |

---

## 💰 Current Investment Status

- ✅ Vast.ai GPU: Rented and ready
- ✅ Hetzner VPS: Running (minimal cost)
- 🟡 Both servers on hold until sync works
- ⏳ Waiting for resolution to proceed

---

## 🔗 Resources

- **Gonka Repository:** https://github.com/gonka-ai/gonka
- **Bug Report:** https://github.com/gonka-ai/gonka/issues/431
- **Official Docs:** https://gonka.ai

---

**Status:** 🔴 Stage 1 Complete - Project Blocked

*Stage 2 report will be published once the Docker image issue is resolved and full deployment is successful.*

