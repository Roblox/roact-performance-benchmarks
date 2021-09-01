#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

declare -A event_map
event_map[Ir]="TotalInstructionsExecuted"
event_map[I1mr]="L1_InstrReadCacheMisses"
event_map[ILmr]="LL_InstrReadCacheMisses"
event_map[Dr]="TotalMemoryReads"
event_map[D1mr]="L1_DataReadCacheMisses"
event_map[DLmr]="LL_DataReadCacheMisses"
event_map[Dw]="TotalMemoryWrites"
event_map[D1mw]="L1_DataWriteCacheMisses"
event_map[DLmw]="LL_DataWriteCacheMisses"
event_map[Bc]="ConditionalBranchesExecuted"
event_map[Bcm]="ConditionalBranchMispredictions"
event_map[Bi]="IndirectBranchesExecuted"
event_map[Bim]="IndirectBranchMispredictions"

now_ms() {
    echo -n $(date +%s%N | cut -b1-13)
}

# Run cachegrind on a given benchmark and echo the results.
CLI_VERSION=$($1 version | tr -d '\n')
ITERATION_COUNT=$4
START_TIME=$(now_ms)

valgrind \
    --quiet \
    --tool=cachegrind \
    "$1" run \
        --load.model model.rbxm \
        --run "$2" \
        --headlessRenderer 1 \
        --lua.globals minSamples=$ITERATION_COUNT \
        --lua.globals cachegrind=true \
    >/dev/null

TIME_ELAPSED=$(bc <<< "$(now_ms) - ${START_TIME}")

# Generate report using cg_annotate and extract the header and totals of the
# recorded events valgrind was configured to record.
CG_RESULTS=$(cg_annotate $(ls -t cachegrind.out.* | head -1))
CG_HEADERS=$(grep -B2 'PROGRAM TOTALS$' <<< "$CG_RESULTS" | head -1 | sed -E 's/\s+/\n/g' | sed '/^$/d')
CG_TOTALS=$(grep 'PROGRAM TOTALS$' <<< "$CG_RESULTS" | head -1 | grep -Po '[0-9,]+\s' | tr -d ', ')

TOTALS_ARRAY=($CG_TOTALS)
HEADERS_ARRAY=($CG_HEADERS)

# Map the results to the format that the benchmark script expects.
for i in "${!TOTALS_ARRAY[@]}"; do
    TOTAL=${TOTALS_ARRAY[$i]}
    EVENT_NAME=${event_map[${HEADERS_ARRAY[$i]}]}

    OPS_PER_SEC=$(bc -l <<< "($TOTAL / $TIME_ELAPSED) * 1000")
    STD_DEV="0%"
    RUNS="1"

    printf "%s#%s x %.0f ops/sec ±%s (%d runs sampled)(roblox-cli version %s)\n" \
        "$3" "$EVENT_NAME" "$OPS_PER_SEC" "$STD_DEV" "$RUNS" "$CLI_VERSION"
done

# TODO: Map event names to more human-readable names.
