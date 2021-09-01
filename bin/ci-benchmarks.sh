#!/bin/bash
set -x

clear && printf '\e[3J'

rojo build benchmarks-cli.project.json --output model.rbxm

echo "Remove .robloxrc from dev dependencies"
find Packages/Dev -name "*.robloxrc" | xargs rm -f
find Packages/_Index -name "*.robloxrc" | xargs rm -f

echo "Run static analysis"
roblox-cli analyze benchmarks-cli.project.json
selene src

clear && printf '\e[3J'

# Run concurrent benchmarks.
roblox-cli run --load.model model.rbxm --run scripts/run-first-render-benchmark.lua --headlessRenderer 1
roblox-cli run --load.model model.rbxm --run scripts/run-frame-rate-benchmark.lua --headlessRenderer 1

# Run react benchmarks.
roblox-cli run --load.model model.rbxm --run scripts/run-deep-tree-benchmark.lua --headlessRenderer 1
roblox-cli run --load.model model.rbxm --run scripts/run-wide-tree-benchmark.lua --headlessRenderer 1
roblox-cli run --load.model model.rbxm --run scripts/run-sierpinski-triangle-benchmark.lua --headlessRenderer 1

# Run react benchmarks in cachegrind.
./scripts/run-with-cachegrind.sh roblox-cli scripts/run-deep-tree-benchmark.lua "MountDeepTreeCGCold" 1
./scripts/run-with-cachegrind.sh roblox-cli scripts/run-deep-tree-benchmark.lua "MountDeepTreeCG" 2
./scripts/run-with-cachegrind.sh roblox-cli scripts/run-wide-tree-benchmark.lua "MountWideTreeCGCold" 1
./scripts/run-with-cachegrind.sh roblox-cli scripts/run-wide-tree-benchmark.lua "MountWideTreeCG" 2
./scripts/run-with-cachegrind.sh roblox-cli scripts/run-sierpinski-triangle-benchmark.lua "SierpinskiTriangleCGCold" 1
./scripts/run-with-cachegrind.sh roblox-cli scripts/run-sierpinski-triangle-benchmark.lua "SierpinskiTriangleCG" 2
