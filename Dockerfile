FROM ubuntu:24.04

# Install dependencies
RUN apt-get update \
     && apt-get install -y curl jq git git-lfs \
     && rm -rf /var/lib/apt/lists/*

RUN git lfs install

# Set environment variables
ARG RUNNER_VERSION="2.322.0"

# Create runner user
RUN useradd -m github-runner

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
    chmod +x /github-runner/entrypoint.sh && \
    mkdir -p /work_directory && \
    chown -R github-runner:github-runner /work_directory

# Switch to runner user
USER github-runner
WORKDIR /github-runner

ENTRYPOINT ["./entrypoint.sh"]
