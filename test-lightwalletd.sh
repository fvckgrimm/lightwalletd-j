#!/bin/bash
# Comprehensive Lightwalletd gRPC Testing Commands for Juno Cash

echo "=== BASIC INFO ENDPOINTS ==="

# GetLightdInfo - uses getinfo + getblockchaininfo
grpcurl -plaintext 127.0.0.1:9067 \
  cash.z.wallet.sdk.rpc.CompactTxStreamer/GetLightdInfo

# GetLatestBlock - uses getbestblockhash
grpcurl -plaintext 127.0.0.1:9067 \
  cash.z.wallet.sdk.rpc.CompactTxStreamer/GetLatestBlock

# Ping test
grpcurl -plaintext -d '{}' \
  127.0.0.1:9067 cash.z.wallet.sdk.rpc.CompactTxStreamer/Ping


echo -e "\n=== BLOCK RETRIEVAL ==="

# GetBlock - uses getblock
grpcurl -plaintext -d '{"height": "0"}' \
  127.0.0.1:9067 cash.z.wallet.sdk.rpc.CompactTxStreamer/GetBlock

# GetBlock by hash
grpcurl -plaintext -d '{"hash": "0091ff2592b34a24eb014637f76c5ee416ce7a6928e8940f96e78954351d70bc"}' \
  127.0.0.1:9067 cash.z.wallet.sdk.rpc.CompactTxStreamer/GetBlock

# GetBlockRange - uses getblock in a loop
grpcurl -plaintext -d '{"start": {"height": "0"}, "end": {"height": "5"}}' \
  127.0.0.1:9067 cash.z.wallet.sdk.rpc.CompactTxStreamer/GetBlockRange

# Get latest 10 blocks
grpcurl -plaintext -d '{"start": {"height": "49000"}, "end": {"height": "49010"}}' \
  127.0.0.1:9067 cash.z.wallet.sdk.rpc.CompactTxStreamer/GetBlockRange


echo -e "\n=== TREE STATE ==="

# GetTreeState - uses z_gettreestate
grpcurl -plaintext -d '{"height": "1"}' \
  127.0.0.1:9067 cash.z.wallet.sdk.rpc.CompactTxStreamer/GetTreeState

# GetLatestTreeState
grpcurl -plaintext 127.0.0.1:9067 \
  cash.z.wallet.sdk.rpc.CompactTxStreamer/GetLatestTreeState

# GetSubtreeRoots (Orchard)
grpcurl -plaintext -d '{"shieldedProtocol": "orchard", "maxEntries": 10}' \
  127.0.0.1:9067 cash.z.wallet.sdk.rpc.CompactTxStreamer/GetSubtreeRoots

# GetSubtreeRoots (Sapling)
grpcurl -plaintext -d '{"shieldedProtocol": "sapling", "maxEntries": 10}' \
  127.0.0.1:9067 cash.z.wallet.sdk.rpc.CompactTxStreamer/GetSubtreeRoots


echo -e "\n=== TRANSACTION OPERATIONS ==="

# GetTransaction - uses getrawtransaction
# (Replace with actual txid from your chain)
grpcurl -plaintext -d '{"hash": "your_txid_here"}' \
  127.0.0.1:9067 cash.z.wallet.sdk.rpc.CompactTxStreamer/GetTransaction

# SendTransaction - uses sendrawtransaction
# (You need a signed raw transaction hex)
# grpcurl -plaintext -d '{"data": "raw_tx_hex_here", "height": 0}' \
#   127.0.0.1:9067 cash.z.wallet.sdk.rpc.CompactTxStreamer/SendTransaction


echo -e "\n=== MEMPOOL ==="

# GetMempoolTx - uses getrawmempool
grpcurl -plaintext -d '{}' \
  127.0.0.1:9067 cash.z.wallet.sdk.rpc.CompactTxStreamer/GetMempoolTx

# GetMempoolStream - streaming version
grpcurl -plaintext -d '{}' \
  127.0.0.1:9067 cash.z.wallet.sdk.rpc.CompactTxStreamer/GetMempoolStream


echo -e "\n=== TRANSPARENT ADDRESS OPERATIONS ==="

# GetTaddressBalance - uses getaddressbalance
# (Replace with actual t-address)
grpcurl -plaintext -d '{"addresses": ["t1YourAddressHere"]}' \
  127.0.0.1:9067 cash.z.wallet.sdk.rpc.CompactTxStreamer/GetTaddressBalance

# GetTaddressTxids - uses getaddresstxids
grpcurl -plaintext -d '{"address": "t1YourAddressHere", "startHeight": 0, "endHeight": 1000}' \
  127.0.0.1:9067 cash.z.wallet.sdk.rpc.CompactTxStreamer/GetTaddressTxids

# GetAddressUtxos - uses getaddressutxos
grpcurl -plaintext -d '{"addresses": ["t1YourAddressHere"]}' \
  127.0.0.1:9067 cash.z.wallet.sdk.rpc.CompactTxStreamer/GetAddressUtxos

# GetAddressUtxosStream - streaming version
grpcurl -plaintext -d '{"addresses": ["t1YourAddressHere"]}' \
  127.0.0.1:9067 cash.z.wallet.sdk.rpc.CompactTxStreamer/GetAddressUtxosStream


echo -e "\n=== ADVANCED QUERIES ==="

# GetBlockNullifiers - useful for wallet sync
grpcurl -plaintext -d '{"height": "100"}' \
  127.0.0.1:9067 cash.z.wallet.sdk.rpc.CompactTxStreamer/GetBlockNullifiers

# GetBlockRangeNullifiers
grpcurl -plaintext -d '{"start": {"height": "0"}, "end": {"height": "10"}}' \
  127.0.0.1:9067 cash.z.wallet.sdk.rpc.CompactTxStreamer/GetBlockRangeNullifiers


echo -e "\n=== USEFUL ONE-LINERS ==="

# Monitor sync status
echo "Current block height:"
grpcurl -plaintext 127.0.0.1:9067 \
  cash.z.wallet.sdk.rpc.CompactTxStreamer/GetLatestBlock | grep -o '"height":"[^"]*"'

# Check if node is synced
echo "Node info:"
grpcurl -plaintext 127.0.0.1:9067 \
  cash.z.wallet.sdk.rpc.CompactTxStreamer/GetLightdInfo | jq -r '.blockHeight, .estimatedHeight'

# Get genesis block info
echo "Genesis block:"
grpcurl -plaintext -d '{"height": "0"}' \
  127.0.0.1:9067 cash.z.wallet.sdk.rpc.CompactTxStreamer/GetBlock | jq

# Watch for new blocks (run in background)
echo "Watching for new blocks..."
while true; do
  grpcurl -plaintext 127.0.0.1:9067 \
    cash.z.wallet.sdk.rpc.CompactTxStreamer/GetLatestBlock | \
    jq -r '.height' | \
    xargs -I {} echo "Current height: {}"
  sleep 30
done


echo -e "\n=== TESTING WITH REAL DATA ==="

# Get a real transaction from block 1 (if it has transactions)
echo "Block 1 details:"
grpcurl -plaintext -d '{"height": "1"}' \
  127.0.0.1:9067 cash.z.wallet.sdk.rpc.CompactTxStreamer/GetBlock | jq

# Get recent blocks with transactions
echo "Recent blocks (last 5):"
LATEST=$(grpcurl -plaintext 127.0.0.1:9067 \
  cash.z.wallet.sdk.rpc.CompactTxStreamer/GetLatestBlock | \
  jq -r '.height' | tr -d '"')
START=$((LATEST - 5))
grpcurl -plaintext -d "{\"start\": {\"height\": \"$START\"}, \"end\": {\"height\": \"$LATEST\"}}" \
  127.0.0.1:9067 cash.z.wallet.sdk.rpc.CompactTxStreamer/GetBlockRange


echo -e "\n=== HEALTH CHECK SCRIPT ==="
echo "Running health checks..."

# 1. Check connection
if grpcurl -plaintext 127.0.0.1:9067 list > /dev/null 2>&1; then
  echo "✓ gRPC server is reachable"
else
  echo "✗ Cannot connect to gRPC server"
  exit 1
fi

# 2. Check lightwalletd info
INFO=$(grpcurl -plaintext 127.0.0.1:9067 \
  cash.z.wallet.sdk.rpc.CompactTxStreamer/GetLightdInfo)
if echo "$INFO" | grep -q "chainName"; then
  echo "✓ GetLightdInfo working"
  echo "  Chain: $(echo "$INFO" | jq -r '.chainName')"
  echo "  Height: $(echo "$INFO" | jq -r '.blockHeight')"
  echo "  Branch: $(echo "$INFO" | jq -r '.consensusBranchId')"
else
  echo "✗ GetLightdInfo failed"
fi

# 3. Check block retrieval
if grpcurl -plaintext -d '{"height": "0"}' \
  127.0.0.1:9067 cash.z.wallet.sdk.rpc.CompactTxStreamer/GetBlock | grep -q "hash"; then
  echo "✓ Block retrieval working"
else
  echo "✗ Block retrieval failed"
fi

# 4. Check tree state
if grpcurl -plaintext 127.0.0.1:9067 \
  cash.z.wallet.sdk.rpc.CompactTxStreamer/GetLatestTreeState | grep -q "orchardTree"; then
  echo "✓ Tree state working"
else
  echo "✗ Tree state failed"
fi

# 5. Check subtree roots
if grpcurl -plaintext -d '{"shieldedProtocol": "orchard"}' \
  127.0.0.1:9067 cash.z.wallet.sdk.rpc.CompactTxStreamer/GetSubtreeRoots 2>&1 | grep -qv "InvalidArgument"; then
  echo "✓ Subtree roots working"
else
  echo "⚠ Subtree roots may not be enabled (need -experimentalfeatures -lightwalletd)"
fi

echo -e "\nHealth check complete!"
