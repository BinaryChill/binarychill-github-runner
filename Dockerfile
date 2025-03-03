FROM ubuntu:24.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
        curl \
        jq \
        git git-lfs \
        libicu-dev \
        docker.io && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables
ARG RUNNER_VERSION="2.322.0"
ARG GITHUB_URL
ARG RUNNER_TOKEN
ARG GITHUB_RUNNER_CONFIGURED_FLAG
ARG GITHUB_RUNNER_USER_ID
ARG GITHUB_RUNNER_GROUP_ID

# Create github-runner user, give it docker group (from host group list)
RUN useradd -u $GITHUB_RUNNER_USER_ID github-runner && \
    usermod -aG docker github-runner  && \
    groupmod -g $GITHUB_RUNNER_GROUP_ID docker

# Download runner binary
RUN mkdir -p /home/github-runner && \
    mkdir -p /home/github-runner/github_runner_data && \
    curl -L -o /home/github-runner/actions-runner.tar.gz \
        https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz  && \
    tar xzf /home/github-runner/actions-runner.tar.gz -C /home/github-runner/github_runner_data  && \
    rm /home/github-runner/actions-runner.tar.gz 

# Setup permissions
COPY entrypoint.sh /entrypoint.sh
RUN chown -R github-runner:github-runner /home/github-runner/github_runner_data && \
    chown github-runner:github-runner /entrypoint.sh && \
    chmod +x /entrypoint.sh

# Switch to runner user
USER github-runner
WORKDIR /github_runner_data

ENTRYPOINT ["/entrypoint.sh"]
