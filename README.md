# binarychill-github-runner
Dockerized github runner to be hosted as a docker application in coolify.

# Configuration
Setup the two following env variables in coolify project:
- GITHUB_URL=https://github.com/YOUR_USER
- RUNNER_TOKEN=YOUR_GENERATED_TOKEN
- RUNNER_VERSION=2.322.0

As the runner needs access to docker for actions, you need to add the following docker parameter in Custom Docker Options:
```
--privileged
```