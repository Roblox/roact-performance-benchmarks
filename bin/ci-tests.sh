#!/bin/bash

set -x

echo "Install dependencies"
rotrieve install

echo "Remove .robloxrc from dev dependencies"
find Packages/Dev -name "*.robloxrc" | xargs rm -f
find Packages/_Index -name "*.robloxrc" | xargs rm -f

echo "Run static analysis"
roblox-cli analyze --project tests.project.json
selene src/ concurrent/
stylua -c src/ concurrent/

echo "Run tests in DEV"
roblox-cli run --load.model tests.project.json \
  --run scripts/spec.lua \
  --testService.errorExitCode=1 \
  --fastFlags.overrides "UseDateTimeType3=true" "EnableLoadModule=true" "EnableDelayedTaskMethods=true" \
  --lua.globals=UPDATESNAPSHOT=false \
  --lua.globals=CI=true \
  --lua.globals=__DEV__=true

echo "Run tests in release"
roblox-cli run --load.model tests.project.json \
  --run scripts/spec.lua \
  --testService.errorExitCode=1 \
  --fastFlags.overrides "UseDateTimeType3=true" "EnableLoadModule=true" "EnableDelayedTaskMethods=true" \
  --lua.globals=UPDATESNAPSHOT=false \
  --lua.globals=CI=true
