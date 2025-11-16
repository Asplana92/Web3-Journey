README — Gonka Infrastructure Deployment
Full lifecycle of joining the Gonka Network as an Infra Operator (Stage 1 → Stage 2)

This directory documents the complete technical journey of deploying a production-ready Gonka inference node across a distributed infrastructure environment.
The goal is to provide reference-grade material for operators, contributors, and researchers exploring decentralized AI networks.

📌 Contents

Gonka/
├── Stage1-Investigation.md
├── Stage 2 Deployment Report
└── Gonka-Full-Technical-Report.md

Each document reflects a different layer of the journey:

1. Stage1-Investigation.md

A detailed analysis of the initial deployment issues:

AppHash mismatch

Trust period expiry

Genesis replay failure

Chain node sync debugging

Issue #431 root-cause validation

This stage documents all findings that led to switching from genesis sync → snapshot sync.

2. Stage 2 Deployment Report

A compact summary of:

Successful chain + API deployment

GPU node setup

Tailscale networking

Hardware registration

Validation and health checks

Focuses on practical steps required to reach operational status.

3. Gonka-Full-Technical-Report.md

A complete 15–20 page technical overview combining both stages into a single reference document:

Full journey from zero to production

Architecture diagrams

Snapshot resolution

Networking and secure key management

GPU inference backend

Adapter implementation

Watchdog automation

Hardware registration

Epoch assignment logic

Lessons learned and best practices

This is the authoritative documentation for the Gonka node deployment.

🧩 Architecture Overview

The production setup consists of:

Hetzner VPS: Chain node + API node + warm keyring

Vast.ai GPU instance: llama-server + adapter + watchdog

Tailscale mesh VPN: encrypted private networking

Gonka Network: consensus + inference layer

All components are isolated, reproducible, and validated.

🎯 Objectives of This Folder

This directory serves as:

A complete technical reference for Gonka node deployment

A reproducible guide for new infra operators

An audit-friendly record of all actions taken

A foundation for future stages (monitoring, scaling, automation)

A documented contribution to the decentralized AI ecosystem

🌐 Related Issues & Contributions

The deployment includes investigation and reproduction of:

Issue #431 — Snapshot Sync / AppHash Mismatch

Issue #438 — Model ID Governance Matching

Both issues resulted in documented findings and improved clarity for the network.

🚀 Current Status

Chain node: Synced

API node: Operational

GPU node: Serving inference

Hardware: Registered

Epoch Assignment: Pending (normal behavior)

Architecture: Production-ready
