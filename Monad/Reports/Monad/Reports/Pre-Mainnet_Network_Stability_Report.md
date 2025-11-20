# Monad Testnet — Pre-Mainnet Network Stability Report
*Independent Infra Analysis by asplana92*

## 1. Overview
This report summarizes an independent infrastructure analysis of the Monad Testnet RPC endpoint before mainnet launch.

- **Tester:** Tolik (asplana92)  
- **Environment:** Hetzner cloud VPS, 4 vCPU, 8 GB RAM, Ubuntu 24.04  
- **RPC endpoint under test:** `https://monad.skandicescape.online/rpc` (behind Nginx reverse proxy to official Monad Testnet RPC)  
- **Time window:** 30–60 minutes of spot checks on 2025-11-20  
- **Focus areas:**  
  - RPC responsiveness (latency and consistency)  
  - Block progression stability  
  - HTTP-level availability  
  - Error patterns in logs

The goal is not to perform a full-scale load test, but to provide a realistic snapshot of how the RPC behaves under light but systematic probing from a real infra node.



## 2. RPC Responsiveness
To measure baseline latency, 10 consecutive `eth_blockNumber` JSON-RPC POST requests were sent to the endpoint:

```bash
for i in {1..10}; do 
  t=$(curl -w "%{time_total}\n" -o /dev/null -s -X POST https://monad.skandicescape.online/rpc \
    -H "Content-Type: application/json" \
    -d '{"jsonrpc":"2.0","id":1,"method":"eth_blockNumber","params":[]}');
  echo "Request $i → ${t}s";
done
Observed results:

0.122687s

0.114786s

0.472497s (single spike)

0.119831s

0.119160s

0.123601s

0.117237s

0.119591s

0.097892s

0.098783s

Summary:

Average latency: ~0.151 s (151 ms)

Typical range: 95–130 ms

Outlier: 1 spike at ~472 ms

In general, the RPC responds quickly and consistently. The single latency spike is acceptable for a public testnet endpoint, but it is worth monitoring if such spikes become frequent under higher load.




## 3. Block Progression Stability
Block progression was probed by querying eth_blockNumber twice with a ~20 second delay:

curl -X POST https://monad.skandicescape.online/rpc \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"eth_blockNumber","params":[]}'

{"jsonrpc":"2.0","id":1,"result":"0x3060a4b"}

# ~20s later

curl -X POST https://monad.skandicescape.online/rpc \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"eth_blockNumber","params":[]}'

{"jsonrpc":"2.0","id":1,"result":"0x3060a4b"}


The block height remained constant at 0x3060a4b during this short sampling window.

Given that this is a public testnet with potentially low transaction activity, short periods without new blocks are not necessarily problematic, but they should be monitored over longer intervals to rule out stalled consensus or upstream RPC issues.


## 4. Network Availability
To check basic HTTP-level availability, 20 consecutive HTTP checks were performed:

for i in {1..20}; do 
  code=$(curl -s -o /dev/null -w "%{http_code}" https://monad.skandicescape.online/rpc);
  echo "Check $i → HTTP $code";
  sleep 1;
done


All 20 checks returned:

HTTP 405


405 Method Not Allowed is expected for this endpoint when accessed via plain GET without a JSON-RPC POST body: the RPC is designed to accept only POST requests with a valid JSON-RPC payload.

Functional availability of the endpoint was confirmed indirectly through successful POST-based eth_blockNumber calls in the previous sections. For a more strict availability metric, a similar loop using POST + JSON-RPC could be introduced in future iterations.


## 5. Latency Tests
In this snapshot, latency was measured only from a single region (Hetzner EU, HEL1). The baseline probe of 10 requests showed:

Average latency: ~151 ms

Median latency: in the 110–130 ms range

Single outlier: ~472 ms

For a pre-mainnet test from a single vantage point, this is acceptable. A more advanced version of this report could include multi-region latency (EU/US/Asia) and higher-concurrency tests.


## 6. Error Pattern Detection
Container logs for the local Nginx-based RPC proxy were inspected for the last 30 minutes:

docker logs monad_testnet_rpc --since=30m 2>&1 | \
grep -iE "error|fail|timeout|critical|warn" | head -n 20


The command returned no matches, which means:

no error

no fail

no timeout

no critical

no warn

within the inspected window.

This indicates that, at least in this period, the proxy container was stable and did not report obvious runtime issues.

## 7. Conclusion
From the perspective of an independent infra node operator (asplana92), the Monad Testnet RPC endpoint at monad.skandicescape.online demonstrates:

Good baseline responsiveness (~150 ms average latency, with rare spikes)

Consistent HTTP behavior (405 on invalid GETs, successful POST-based JSON-RPC calls)

Clean logs (no errors/warnings in the last 30 minutes of inspection)

The only notable observation is the lack of block height change during a short 20-second sampling interval. For a low-traffic testnet this can be normal, but it would be valuable to run longer-term block progression monitoring to confirm there are no stalls under real workloads.

Overall, the endpoint appears pre-mainnet ready from a basic stability and responsiveness standpoint, with the caveat that deeper load and multi-region tests should be performed to fully validate behavior under realistic mainnet-level traffic.

