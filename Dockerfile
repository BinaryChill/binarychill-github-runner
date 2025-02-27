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

# Create github-runner user
RUN useradd -m github-runner && \
    usermod -aG docker github-runner 

RUN mkdir -p /var/lib/docker

# Download runner binary
RUN mkdir -p /github-runner && \
    mkdir -p /home/github-runner && \
    curl -L -o /home/github-runner/actions-runner.tar.gz \
        https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz  && \
    tar xzf /home/github-runner/actions-runner.tar.gz -C /github-runner  && \
    rm /home/github-runner/actions-runner.tar.gz 

# Setup permissions
COPY entrypoint.sh /github-runner/entrypoint.sh
RUN chown -R github-runner:github-runner /github-runner && \
    chmod +x /github-runner/entrypoint.sh

# Switch to runner user
USER github-runner
WORKDIR /github-runner

ENTRYPOINT ["./entrypoint.sh"]
