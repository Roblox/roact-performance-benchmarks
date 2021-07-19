#!/bin/bash

set -x

clear && printf '\e[3J'

rojo build benchmarks-cli.project.json --output model.rbxm

echo "Remove .robloxrc from dev dependencies"
find Packages/Dev -name "*.robloxrc" | xargs rm -f
find Packages/_Index -name "*.robloxrc" | xargs rm -f

echo "Run static analysis"
roblox-cli analyze ci.project.json
selene src

clear && printf '\e[3J'

roblox-cli run --load.model model.rbxm --run scripts/run-first-render-benchmark.lua --headlessRenderer 1
roblox-cli run --load.model model.rbxm --run scripts/run-frame-rate-benchmark.lua --headlessRenderer 1

roblox-cli run --load.model model.rbxm --run scripts/run-deep-tree-benchmark.lua --headlessRenderer 1
roblox-cli run --load.model model.rbxm --run scripts/run-wide-tree-benchmark.lua --headlessRenderer 1
roblox-cli run --load.model model.rbxm --run scripts/run-sierpinski-triangle-benchmark.lua --headlessRenderer 1
