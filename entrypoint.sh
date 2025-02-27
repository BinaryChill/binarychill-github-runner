#!/bin/bash
set -e

echo "Configuring runner: binarychill-github-runner $RUNNER_VERSION for host $GITHUB_REPO_URL"

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
