#!/bin/bash

set -ex

echo "Install dependencies"
rotrieve install
echo "Build project"
rojo build tests.project.json --output model.rbxmx
echo "Remove .robloxrc from dev dependencies"
find Packages/Dev -name "*.robloxrc" | xargs rm -f
find Packages/_Index -name "*.robloxrc" | xargs rm -f

# echo "Run static analysis"
# roblox-cli analyze tests.project.json
# selene src

echo "Run tests in DEV"
roblox-cli run --load.model model.rbxmx --run scripts/spec.lua --testService.errorExitCode=1 --fastFlags.overrides EnableLoadModule=true --lua.globals=__DEV__=true
echo "Run tests in release"
roblox-cli run --load.model model.rbxmx --run scripts/spec.lua --testService.errorExitCode=1 --fastFlags.overrides EnableLoadModule=true