#!/bin/bash

set -ex

clear && printf '\e[3J'

rojo build concurrent-cli.project.json --output concurrent-ci.rbxm
rojo build benchmarks-cli.project.json --output benchmarks-ci.rbxm

echo "Remove .robloxrc from dev dependencies"
find Packages/Dev -name "*.robloxrc" | xargs rm -f
find Packages/_Index -name "*.robloxrc" | xargs rm -f

# echo "Run static analysis"
# roblox-cli analyze ci.project.json
# selene src

clear && printf '\e[3J'

roblox-cli run --load.model concurrent-ci.rbxm --run scripts/run-first-render-benchmark.lua --headlessRenderer 1
roblox-cli run --load.model concurrent-ci.rbxm --run scripts/run-frame-rate-benchmark.lua --headlessRenderer 1

roblox-cli run --load.model benchmarks-ci.rbxm --run scripts/run-deep-tree-benchmark.lua --headlessRenderer 1
roblox-cli run --load.model benchmarks-ci.rbxm --run scripts/run-wide-tree-benchmark.lua --headlessRenderer 1
