# binarychill-github-runner
Dockerized github runner to be hosted as a docker application in coolify.
Coolify "restart" button seems to note kill active process. Redeploy the application if needed instead.

# Prerequisite
- `docker` group on the host
- `github-runner` user on the host
  - With the group `docker`
- `/var/run/docker.sock` accessible to group `docker`
- `/github_runner_data` accessible to group `docker`
- `/github_work_directory` accessible to group `docker`
- Volume to the docker socket
- Volume to `/github_runner_data`
- Volume to `/github_work_directory`

# Configuration
Setup the two following env variables in coolify project:
- GITHUB_URL=https://github.com/YOUR_USER
- RUNNER_TOKEN=YOUR_GENERATED_TOKEN
- RUNNER_VERSION=2.322.0
- GITHUB_RUNNER_CONFIGURED_FLAG
  - Lock file created after configuration to skip configuration on next start
- GITHUB_RUNNER_USER_ID
  - `github-runner` User ID on the host
- GITHUB_RUNNER_GROUP_ID
  - `docker` Group ID on the host

As the runner needs access to docker for actions, you need to add the following docker parameter in Custom Docker Options:
```
--privileged
```

To avoid any permission error on the file created by the action's runner, use the following ACL commands on the host to allow automatic propagation of write permission for group.
```sh
sudo setfacl -d -m g::rwx /github_work_directory
sudo setfacl -m g::rwx /github_work_directory

sudo chmod -R g+w /github_work_directory
```
Expected result:
```
getfacl /github_work_directory

# file: github_work_directory
# owner: github-runner
# group: docker
# flags: -s-
user::rwx
group::rwx
other::---
default:user::rwx
default:group::rwx
default:other::---
```
