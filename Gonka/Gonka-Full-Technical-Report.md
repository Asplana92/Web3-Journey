Gonka Network — Full Technical Deployment Report
Stage 1 + Stage 2 Infrastructure Journey

Status: Operational · Awaiting Epoch Assignment
Author: Infra Builder

1. Executive Summary

This document provides a complete and consolidated technical overview of the entire Gonka infrastructure journey — from the initial deployment attempts, through system debugging and issue resolution (Stage 1), to a fully functioning inference node architecture (Stage 2). It reflects the full lifecycle of building a decentralized ML node across heterogeneous environments (Hetzner, Vast.ai) with secure networking, GPU inference, and on-chain hardware registration.

The report is written from an infrastructure engineer’s perspective, focusing on correctness, reproducibility, clarity, and operational best practices.

2. Background

The goal of this deployment was to:

Join the Gonka Network as a participant

Deploy both the chain node and GPU inference node

Resolve observed synchronization issues

Register GPU hardware on-chain

Create an autonomous, stable, and production-ready environment

Document the process for other operators

During this journey, two critical issues were investigated:

Issue #431 — AppHash mismatch during genesis sync

Issue #438 — Governance model ID mismatch during hardware registration

These investigations led to multiple contributions and direct improvements to the stability and documentation of the network.

3. Stage 1 — Initial Deployment & Issues

First deployment attempts revealed several issues preventing the node from joining the network:

3.1 AppHash mismatch
Error: AppHash mismatch
Expected X, got Y

3.2 Trust period expired
trust period expired (77 days)

3.3 Genesis sync blocked

Chain node could not replay historical blocks due to extended chain age.

3.4 API cannot initialize

API relies on the chain node; with consensus blocked, the API layer never reaches operational state.

These symptoms pointed to a deeper inconsistency between the chain state and the expected genesis replay behavior.

4. Stage 1 Root Cause Analysis

The investigation confirmed:

Root cause:

Version v0.2.4 cannot join the network using genesis sync.

This was validated directly by maintainers in Issue #431.

Correct behavior:

Nodes must join using snapshot sync, not genesis replay.

Snapshot-based state synchronization provides:

a trusted block header

a verified app hash

a valid state snapshot

significantly reduced sync time

compatibility with v0.2.4+

Once this insight was applied, all previous blockers were resolved.

5. Switching to Snapshot Sync

After applying the correct method:

cd ~/gonka/deploy/join
docker compose up -d


The compose configuration automatically:

downloads the appropriate snapshot

loads a trusted block

initializes the validator set

syncs forward with SYNC_WITH_SNAPSHOTS=true

This eliminated AppHash mismatch and trust period issues.

6. Architecture Overview (Stage 2)

The final production setup consists of two independent machines linked via a secure Tailscale VPN:

                 ┌───────────────────────────────┐
                 │           HETZNER VPS          │
                 │────────────────────────────────│
                 │ • Chain Node (Tendermint)      │
                 │ • API Node (Gonka API)         │
                 │ • Warm Keyring                 │
                 │ • Monitoring / Health Checks   │
                 └───────────────▲────────────────┘
                                 │  Tailscale VPN (~30 ms)
                                 ▼
        ┌────────────────────────────────────────────────────────┐
        │                      VAST.AI GPU INSTANCE              │
        │────────────────────────────────────────────────────────│
        │ • llama-server (Qwen2.5-7B)                            │
        │ • mlnode_adapter (Gonka-compatible API)                │
        │ • Watchdog (auto-recovery)                             │
        │ • Secure private networking via Tailscale              │
        └───────────────────────────────▲────────────────────────┘
                                        │
                                        ▼
                         Gonka Network — Inference Layer

Component Responsibilities
Component	Responsibility
Chain Node	Consensus, state machine, block execution
API Node	Participant/hardware registration, inference routing
GPU Node	High-performance ML inference (LLM)
Tailscale	Secure private transport
Watchdog	Automated recovery

The architecture ensures clean isolation, reliability, and predictable performance.


7. Infrastructure Preparation
7.1 Server roles

Hetzner: chain + API

Vast.ai: GPU inference

7.2 Key management

Cold key (offline): governance transactions, authz grants

Warm key (server): operational tasks

Authz system: delegated permission to submit hardware registration TXs

This aligns with best practices for decentralized networks.


8. Chain Node Deployment
Clean start
cd ~/gonka/deploy/join
docker compose down
rm -rf .inference/data
mkdir .inference/data

Start with snapshot sync
docker compose up -d

Verification
curl -s localhost:26657/status | jq '.result.sync_info.catching_up'
# false


Chain node fully synced.


9. API Node Setup

The API container requires access to the warm keyring stored in the chain node.

Fix keyring access
docker cp node:/root/.inference/keyring-file api:/root/.inference/
docker compose restart api


With the correct keyring, the API node can:

register the participant

submit hardware registration

respond to model queries


10. GPU Node (Vast.ai)

The GPU node runs the inference backend:

10.1 LLM server
llama-server \
  --model qwen2.5-7b-instruct-q6_k.gguf \
  --ctx-size 8192 \
  --n-gpu-layers 99 \
  --host 0.0.0.0 \
  --port 8081
  
10.2 Adapter layer

A FastAPI-based adapter exposes Gonka-compatible endpoints.

Responsibilities:

/health for model discovery

/infer for text generation

translation of Gonka requests → llama.cpp prompts


11. Tailscale Networking

Because Vast.ai blocks inbound ports, a private VPN mesh is required.

Installation
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up

Benefits

encrypted tunnel

private addressing

no public ports

stable low-latency transport (~30ms)


12. Hardware Registration
Steps

Register participant (warm key)

Authorize hardware registration via cold key

Submit registration through API

Confirm on-chain

Verification
inferenced query inference hardware-nodes-all


Hardware appears with correct configuration.


13. Epoch Assignment Logic

Selection of active hardware is randomized per epoch.

Nodes that register after the epoch starts:

will show STOPPED

will be assigned in future epochs

do not indicate misconfiguration

This behavior is expected.


14. Health & Validation

All components confirmed operational:

Component	Status
Chain Node	Synced
API Node	Active
GPU Node	Serving inference
Tailscale	Connected
Hardware	Registered

The system is ready for active inference when selected.


15. Automation / Watchdog

A lightweight watchdog ensures service recovery:

Restarts llama-server if stopped

Restarts adapter

Reconnects Tailscale if disconnected

This guarantees high uptime without heavy orchestration.


16. Investigation: Issue #438

The governance model ID mismatch issue was reproduced and diagnosed.
Cause: governance expects exact string match for model IDs.

Outcome:

clarified expected naming

improved documentation accuracy

validated adapter model behavior


17. Lessons Learned
Technical

Snapshot sync is mandatory for older Tendermint networks

VPN tunneling is essential on GPU hosts

Keyring synchronization is critical for multi-service setups

ML adapter must strictly follow governance model IDs

Operational

test each component independently

automate essential recovery paths

monitor model endpoints

document all changes continuously


18. Recommendations

Always use snapshots with v0.2.4+

Use Tailscale for GPU environments

Use FastAPI/uvicorn for lightweight adapters

Keep warm and cold keys separate

Deploy watchdogs for inference workloads


19. Future Improvements

Prometheus/Grafana integration

Advanced watchdog (Docker healthchecks)

Multi-GPU scaling

Model batching/streaming

Automated snapshot selection


20. Conclusion

The entire Gonka deployment journey—from initial blockers in Block Sync (Stage 1) to a fully operational inference node with GPU integration (Stage 2)—is completed. The system is stable, secure, documented, and production-ready.

This full report serves as a comprehensive blueprint for future operators and contributors within the decentralized ML ecosystem.


