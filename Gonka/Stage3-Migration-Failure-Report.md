Stage 3: Model Migration and Registration Update Failure

# TL;DR — Node Registration Cannot Update After Model Migration

After switching from an unsupported model (Llama) to a governance-approved one...
(и так далее)



Executive Summary

This report documents a critical issue encountered during a model migration: after switching from an unsupported model to a governance-approved model, the node was unable to update its on-chain registration. The API continued using an outdated registration entry, preventing the node from receiving inference assignments.

Status: FAILED — 0 assignments across multiple epochs
Root Cause: On-chain registration update mechanism not detecting differences between local and chain state


Background
Initial Deployment (Epochs 84–87)

The node was originally deployed with:
- Model: Meta-Llama-3.1-8B-Instruct  
- Framework: llama.cpp  
- Hardware: RTX 4090 (limited disk space)  
- Status: Registered and running

Observation: Despite successful registration, the node received zero inference assignments for several epochs.

Community Guidance

A discussion in Discord clarified that:

The originally hosted model is not included in the governance-approved model list.

Only models from:
https://gonka.hyperfusion.io/v1/models

are accepted for inference assignments.

The recommended framework is vLLM, which requires significantly more disk space than the original node had available.

Thus, a migration to a compliant model and environment was required.

Migration Attempt
Phase 1 — Infrastructure Upgrade

To meet the storage and performance requirements for governance-approved models, the ML inference server was migrated to a different machine with significantly more disk space.

The new environment successfully ran:
- Framework: vLLM  
- Model: Qwen/Qwen2.5-7B-Instruct (governance-approved)  
- API endpoint: /v1/models returns correct model list  

Everything on the new server worked correctly at the ML layer.

Phase 2 — Updating Node Configuration

The node’s configuration was updated accordingly:
{
  "id": "node1",
  "host": "<new-host>",
  "inference_port": 8081,
  "poc_port": 8081,
  "models": { "Qwen/Qwen2.5-7B-Instruct": { "args": [] }},
  "hardware": [{ "type": "NVIDIA RTX 4090", "count": 1 }],
  "max_concurrent": 500
}
Actions performed:

Updated node-config.json

Restarted API

Cleared .dapi state directory

Fully restarted infrastructure
Critical Failure: Registration Not Updating
API Behavior

At startup, the API prints the correct configuration from node-config.json:
INFO Registered node … Host:<new-host> Port:8081 Model:Qwen/Qwen2.5-7B-Instruct

However, immediately afterward, the API attempts to contact the old host:
ERROR queryNodeStatus: dial tcp <old-host>:8081: connect: connection refused

This indicates the API is internally reverting to outdated on-chain data.

On-Chain State Remains Stale

Querying the blockchain:
inferenced query inference hardware-nodes-all
returns outdated values, including:

Wrong model

Wrong hardware

Wrong host

Wrong port

Stale values from early testing

Diff Logic Fails to Detect Any Change

Every sync cycle shows:
Hardware diff computed … NewOrModified:[] Removed:[]
No diff to submit

Meaning:

The API believes the old on-chain data and the new local config are identical

Therefore, no update transaction is ever submitted

This leaves the node permanently stuck in the old state.


Root Cause Analysis
1. Stale On-Chain Registration

The initial registration included incorrect values. Those values remain permanently recorded on chain.

2. API Diff Logic Does Not Recognize Changes

Even when every field (host, port, model, hardware) is different, the API still computes:
NewOrModified: []

This strongly suggests that the comparison logic:

Does not compare all fields

Or normalizes data in a way that masks differences

Or uses a lookup key that prevents detecting divergence

3. Legacy Registration May Have Been Accepted Incorrectly

Earlier governance model mismatches (e.g., incomplete prefix matching discussed in issue #438) may have allowed an invalid initial registration, which now blocks updates.

4. Clearing .dapi Does Not Reset On-Chain State

Even with a fully clean local state, the API restores the outdated chain values and refuses to overwrite them.

Impact

Inference epochs missed: Multiple  
Assignments received: 0  
Rewards: 0  

The node is locked in FAILED status, unable to participate in inference despite being correctly configured and fully operational on the new infrastructure.


Attempted Solutions (All Unsuccessful)


| Action                           | Expected            | Result                       |
| -------------------------------- | ------------------- | ---------------------------- |
| Update node-config.json          | New registration    | ❌ Old on-chain data restored |
| Restart API                      | Force re-evaluation | ❌ Falls back to stale config |
| Delete `.dapi` state             | Fresh start         | ❌ No effect                  |
| Restart entire stack             | Full rebuild        | ❌ No update                  |
| Manually edit `config-dump.json` | Override host/model | ❌ Overwritten by API         |


Open Questions for the Gonka Team

How can an operator force the API to submit a new registration transaction when the on-chain record is outdated?

Is there a way to reset or delete an incorrect registration entry?

Does the current diff logic take host/model/hardware changes into account?
Logs indicate no.

Should the operator create a completely new node ID when performing such migrations?

Was the initial incorrect registration stored due to the model-matching bug (#438)?


Recommendations
For Operators

Avoid switching models or infrastructure until a supported migration path exists

Verify model validity before first registration

Ensure all ports are externally reachable before registration

Save chain state snapshots to detect divergence

For Gonka Team

Provide documentation for updating existing registrations

Improve diff logic to detect changes in all fields

Add a “force re-registration” CLI operation

Clarify whether proxies or tunnels are supported

Investigate stale registration persistence logic

Conclusion

A fully valid and functional vLLM + Qwen2.5-7B-Instruct setup was deployed, but the node is unable to join inference due to a persistent stale on-chain registration. The API does not detect differences and therefore never submits the updated configuration.

A path for operators to recover from incorrect initial registrations is needed.


Appendices
A. Network Topology (abstracted)

[API Node]
     ↓
 Reverse Proxy
     ↓
[ML Server]
  vLLM 8081

B. Relevant Config Files

node-config.json

config-dump.json

On-chain query output

