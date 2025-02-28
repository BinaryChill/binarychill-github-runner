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

# Download runner binary
RUN mkdir -p /github-runner && \
    mkdir -p /home/github-runner && \
    curl -L -o /home/github-runner/actions-runner.tar.gz \
        https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz  && \
    tar xzf /home/github-runner/actions-runner.tar.gz -C /github_runner_data  && \
    rm /home/github-runner/actions-runner.tar.gz 

# Setup permissions
COPY entrypoint.sh /github_runner_data/entrypoint.sh
RUN mkdir /github_runner_data && \
    chown -R github-runner:github-runner /github_runner_data && \
    chmod +x /github_runner_data/entrypoint.sh && \
    mkdir /github_work_directory && \
    chown -R github-runner:github-runner /github_work_directory

# Switch to runner user
USER github-runner
WORKDIR /github-runner

ENTRYPOINT ["./entrypoint.sh"]
