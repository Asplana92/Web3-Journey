Gonka Network — Full Technical Deployment Report (Stage 1 + Stage 2)

Infrastructure & Troubleshooting Documentation
Author: Infra Builder (Asplana92)
Date: 2025
Status: Operational – Awaiting Epoch Assignment




📌 Executive Summary

This document provides a full technical record of the entire deployment journey inside the Gonka Network, including:

Stage 1: Investigation & Root Cause Analysis

Stage 2: Deployment, GPU Integration, Tailscale Networking, Hardware Registration

Issue Resolution (#431 & #438)

Architecture design (Chain Node + API + GPU Node)

State Sync and Snapshot-based joining

Automated failover / watchdog setup

Full operational readiness validation

This report is written for technical audiences: infrastructure operators, network developers, and engineers reviewing system performance, edge cases, and contributions.

The goal of this document is to serve as a complete and reliable reference for how to:

diagnose network-level mismatches (AppHash mismatch, trust period issues)

deploy inference nodes on decentralized accelerator networks

work with isolated GPU environments (Vast.ai)

securely manage key roles (cold/warm keys + authz)

ensure zero-downtime inference service availability

maintain correct and verifiable hardware registration

This report contains no personal information and stays within the bounds of clean technical documentation.




📘 Table of Contents

Introduction

Background & Motivation

Initial Setup & Observed Issues (Stage 1)

Root Cause Analysis (Stage 1)

State Sync vs Genesis Sync

Architecture Overview (Stage 2)

Infrastructure Preparation (Servers, Networking, Keys)

Chain Node Deployment

API Node Configuration

GPU Node Deployment (Vast.ai)

Tailscale Networking Architecture

Model Serving & Adapter Layer

Hardware Registration Process

Epoch Assignment Logic

Validation & System Health

Automation & Self-Healing Structure

Investigation: Governance Model Mismatch (#438)

Lessons Learned

Recommendations for Operators

Future Improvements

Conclusion




1. Introduction

This report documents the complete infrastructure journey of deploying and validating a Gonka node environment. The Gonka Network involves a hybrid architecture: a consensus chain node, an API orchestration node, and a GPU inference node capable of serving LLM workloads.

Throughout this process, multiple issues were identified, investigated, reproduced, and resolved. This report consolidates all findings and presents a clean, reproducible blueprint for future operators.




2. Background & Motivation

The deployment journey was motivated by:

establishing a fully functional inference node on the Gonka Network

contributing to network stability by resolving critical issues (#431, #438)

documenting real-world scenarios encountered during decentralized ML operations

building experience with snapshot-driven Tendermint-based networks

integrating GPU computation via secure isolated environments




3. Initial Setup & Observed Issues (Stage 1)

The initial deployment attempt, based strictly on the legacy quickstart instructions, resulted in multiple immediate blockers:

✔ AppHash mismatch on startup
Error: AppHash mismatch
Error: Expected X but got Y

✔ Trust period expiration
Trust period expired (77 days)

✔ Node stuck at height ~0

No ability to re-sync from genesis.

✔ No automatic fallback mechanism

The compose file attempted genesis sync instead of snapshot loading.

✔ API failing to initialize

Because chain node was stuck at mismatch.

The environment was clean (Hetzner VPS), meaning the root cause was not leftover data but upstream incompatibilities.




4. Root Cause Analysis (Stage 1)

After thorough investigation:

Root Cause Identified:

v0.2.4 cannot sync from genesis due to historical state changes.

This was confirmed by maintainers in Issue #431.

Correct Behavior:

Nodes on v0.2.4 must sync using snapshots, not genesis.

Why?

The chain had progressed significantly beyond the point where genesis replay was viable. Trust periods were exceeded (~77 days), making historical light client verification impossible.




5. State Sync vs Genesis Sync

Key insight from Gonka engineers:

“The quickstart instruction deploys from snapshot automatically.”

This clarified that all new nodes must:

download a state snapshot

validate a trusted block

sync forward

rather than attempting to replay blocks from genesis.

Once this was understood, the path forward became stable and reproducible.




6. Architecture Overview (Stage 2)

The full production setup consists of:

┌────────────────────────────────┐       ┌──────────────────────────────┐
│    HETZNER VPS                 │◄─────►│     VAST.AI GPU INSTANCE     │
│                                │ Tailscale VPN                        │
│  • Chain Node (Tendermint)     │ 30 ms │ • llama-server               │
│  • API Node (Gonka API)        │       │ • mlnode_adapter             │
│  • Keyring (warm key)          │       │ • Watchdog cron              │
└────────────────────────────────┘       └──────────────────────────────┘
                │
                ▼
        Gonka Network — Inference Layer


The architecture follows a clean separation of concerns:

Component	Responsibility
Chain Node	consensus, state machine, TX processing
API Node	hardware registration, meta-orchestration
GPU Node	LLM inference backend
Tailscale	secure encrypted communication
Watchdog	service liveness and auto-recovery



7. Infrastructure Preparation
Servers

Hetzner VPS used for Chain + API

Vast.ai GPU instance (RTX-class GPU) for inference workloads

Key separation

Cold Key (offline): governance transactions, grants, sensitive ops

Warm Key (server): operational tasks

Authz: delegated hardware-registration permissions

This follow industry best practices for validator/inference networks.




8. Chain Node Deployment

After applying snapshot-based workflow:

Key steps
cd ~/gonka/deploy/join
docker compose down
rm -rf .inference/data
mkdir .inference/data
docker compose up -d


Compose auto-detected:

SYNC_WITH_SNAPSHOTS=true

TRUSTED_BLOCK_PERIOD=2000

remote seed + state provider

Validation
curl -s localhost:26657/status | jq '.result.sync_info.catching_up'
# false


Chain node fully synced.




9. API Node Configuration

The API node manages:

participant registration

hardware registration

model lookup

request routing

Key integration task

The API must have the same warm-key keyring as the chain node.

Transferred securely:

docker cp node:/root/.inference/keyring-file api:/root/.inference/
docker compose restart api


Once corrected, API was able to submit authorized messages.




10. GPU Node Deployment (Vast.ai)

The GPU node runs:

llama-server

adapter layer for Gonka API compatibility

secure Tailscale tunnel

monitoring + watchdog automation

LLM Server
llama-server \
  --model qwen2.5-7b-instruct-q6_k.gguf \
  --ctx-size 8192 \
  --n-gpu-layers 99 \
  --host 0.0.0.0 \
  --port 8081

Adapter Layer

Designed to translate Gonka inference requests to llama.cpp format.

Supports:

health checks

text generation endpoint

error propagation




11. Tailscale Networking Architecture

Because Vast.ai restricts inbound networking, a VPN mesh was essential.

Benefits:

end-to-end encrypted transport

stable low-latency connection (≈30ms)

no public port exposure

simple service discovery

Setup:
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up




12. Model Serving & Adapter Layer

The adapter interacts with llama-server using FastAPI + HTTPX.

Example flow:

API sends /infer request

Adapter reformats prompt

llama-server generates output

Adapter returns normalized JSON result

The adapter also reports available models via /health.




13. Hardware Registration Process

Steps:

Participant registration

authz delegation from cold key

Hardware registration message submission

API confirms active hardware entry

Verification:
inferenced query inference hardware-nodes-all


Hardware appears with correct model definition.




14. Epoch Assignment Logic

Gonka performs random hardware selection per epoch.

If the node registers after the epoch starts → it will not be selected until next epoch.

STOPPED status means:

hardware registered

waiting for next epoch

no errors in configuration

This is expected behavior.




15. Validation & System Health

All components validated:

Component	Status	Check
Chain Node	✓ Synced	RPC /status
API Node	✓ Active	health endpoint
llama-server	✓ Serving	adapter health
Tailscale	✓ Connected	ping, status
Hardware	✓ Registered	on-chain query

Full system is ready for inference epochs.




16. Automation & Self-Healing Structure

A lightweight watchdog ensures availability:

Checks:

llama-server

adapter

tailscale

Recovery:

restart server if process missing

re-authenticate Tailscale if disconnected

This ensures high uptime with minimal overhead.




17. Investigation: Issue #438 (Governance Model Mismatch)

During registration, a mismatch occurred:

user-provided model name
vs

governance-defined canonical model name

This revealed a validation rule that requires exact string match.

Contributing this issue improved transparency around:

model naming

governance schema

adapter compatibility

Issue submitted with reproduction steps and fix proposal.




18. Lessons Learned
Key Technical Takeaways

Snapshot syncing is mandatory for older Tendermint networks.

State mismatch errors are often caused by outdated genesis.

GPU platforms require VPN tunneling due to port restrictions.

Keyring synchronization is essential for multi-container setups.

Monitoring + watchdog dramatically improves stability.

Best Operational Practices

Keep cold keys offline

Automate minimal failure recovery

Validate each component independently before composition

Always confirm expected model names from governance layer




19. Recommendations for Operators

Prefer snapshot sync > genesis sync

Use Tailscale or similar mesh networks

Log adapter output to identify LLM-level issues

Separate infrastructure concerns by node type

Use cron-based watchdogs for GPU environments

Test inference endpoints locally before registration




20. Future Improvements

Potential enhancements:

Full Prometheus/Grafana metrics integration

Endpoint latency optimization

Model batching or streaming for higher throughput

Multi-GPU scaling

Automated snapshot selector



21. Conclusion

The full Gonka deployment journey progressed from a blocked genesis-sync issue to a fully operational decentralized inference node architecture.

Throughout Stage 1 and Stage 2:

critical network-level blockers were solved

a stable multi-node infrastructure was deployed

GPU inference capability was established

VPN-secured connectivity was implemented

hardware was successfully registered on-chain

The system is production-ready and awaiting epoch assignment, with automated recovery and stable performance across all components.

This report serves as a long-form, technical, professional reference for future operators and developers working with decentralized inference networks.
