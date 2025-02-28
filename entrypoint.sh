#!/bin/bash
set -e

echo "Configuring runner: binarychill-github-runner $RUNNER_VERSION for host $GITHUB_URL"

# Check if the runner is already registered
if [ -f "$CONFIGURED_FLAG" ]; then
    echo "Runner is already registered. Skipping config.sh execution."
else
  ./config.sh --url "$GITHUB_URL" \
              --token "$RUNNER_TOKEN" \
              --name "binarychill-github-runner" \
              --work /github_work_directory \
              --unattended \
              --replace
  touch "$CONFIGURED_FLAG"
fi

echo "Starting runner: binarychill-github-runner $RUNNER_VERSION"

# Run runner
exec ./run.sh
