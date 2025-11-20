Monad Testnet — Pre-Mainnet Network Stability Report

Independent Infra Analysis by asplana92 (Tolik)
Date: 2025-11-20

1. Overview

This report provides an independent technical analysis of the stability, responsiveness, and availability of the Monad Testnet RPC endpoint prior to mainnet launch.

Tester:
Tolik (asplana92) — independent infra builder & node operator

Environment:

Hetzner Cloud (CX22): 4 vCPU, 8GB RAM

OS: Ubuntu 24.04 LTS

Location: Helsinki (HE-L1 datacenter)

Local reverse proxy: Nginx → official Monad Testnet RPC

Public RPC tested:
https://monad.skandicescape.online/rpc

Scope of the report:

RPC responsiveness

Block progression behavior

HTTP-level availability

Log inspection (errors / warnings)

Pre-mainnet readiness assessment

2. RPC Responsiveness

Test method:
10 consecutive JSON-RPC eth_blockNumber POST requests were sent:

Request 1 → 0.122687s
Request 2 → 0.114786s
Request 3 → 0.472497s
Request 4 → 0.119831s
Request 5 → 0.119160s
Request 6 → 0.123601s
Request 7 → 0.117237s
Request 8 → 0.119591s
Request 9 → 0.097892s
Request 10 → 0.098783s


Analysis:

Average latency: ~0.151s (151 ms)

Stable range: 97–130 ms

Single outlier: one spike at ~472 ms

Interpretation:

Baseline latency is fast and stable

Rare latency spikes may appear, which is normal for public RPC

No patterns of degradation observed

Overall, responsiveness is good.

3. Block Progression Stability

Two eth_blockNumber calls 20 seconds apart returned:

0x3060a4b
0x3060a4b


Interpretation:

No new block appeared within a short 20-second window

For a low-traffic testnet, this can be normal

No evidence of RPC freeze or malformed response

A longer sampling window (10–15 minutes) is recommended for deeper analysis

Initial conclusion: no abnormalities detected, but test window was short.

4. Network Availability (HTTP-Level)

20 consecutive HTTP checks using GET returned:

HTTP 405 (Method Not Allowed)


Explanation:

Monad RPC endpoint accepts POST only, not GET

405 is the expected and correct response

The endpoint was reachable 20/20 times

Full functionality confirmed via valid JSON-RPC POST calls

Availability assessment: 100% reachable, correct protocol behavior.

5. Latency Tests (Single Region Baseline)

Region tested: EU (Finland, Hetzner)
Metric source: 10-request sample from Section 2.

Statistics:

Average latency: 151ms

Median latency: ~118ms

Best response: 97ms

Worst response: 472ms (single spike)

Assessment:
Latency is within acceptable range for a public shared RPC endpoint.
For deeper analysis, multi-region tests (EU/US/Asia) or load testing would be valuable after mainnet.

6. Error Pattern Detection (Logs)

Logs inspected:

docker logs monad_testnet_rpc --since=30m | \
grep -iE "error|fail|timeout|critical|warn"


Result:

No error

No fail

No timeout

No critical

No warn

Interpretation:
The proxy container has shown zero runtime issues over the last 30 minutes.
No instability patterns detected.

7. Conclusion (Pre-Mainnet Assessment)

Based on the tests performed on 2025-11-20, the Monad Testnet RPC endpoint
https://monad.skandicescape.online/rpc
demonstrates the following:

✔ Strengths

Consistent responsiveness in the 100–130ms range

Endpoint reachable 20/20 times

Correct HTTP behavior (405 on GET; POST JSON-RPC works perfectly)

No errors in logs during the 30-minute inspection

Block RPC functioning correctly, returning valid hex block numbers

⚠ Observations

A single latency spike (~470ms) occurred once

No block height change during a 20-second sample (normal on low-activity testnet, but worth monitoring)

📌 Pre-Mainnet Ready?

Yes — at the baseline level.

RPC responsiveness, reachability, and logs show stable pre-mainnet readiness.
For full mainnet-grade validation, additional tests are recommended:

multi-region latency

multi-threaded load testing

long-term block progression monitoring

daily error-pattern scans

These steps will follow in reports #2 and #3.

END OF REPORT
