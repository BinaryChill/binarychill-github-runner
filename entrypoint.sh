#!/bin/bash
set -e

# Register runner
./config.sh --url "$GITHUB_URL" \
            --token "$RUNNER_TOKEN" \
            --name "binarychill-github-runner" \
            --work /work_directory \
            --unattended \
            --replace

echo "Starting runner: binarychill-github-runner $RUNNER_VERSION"

# Run runner
exec ./run.sh
