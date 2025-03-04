#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    printf("Cleaning up /github_work_directory.\n");
    return execl("/bin/chown", "chown", "-R", "github-runner", "/github_work_directory", (char *) NULL);
}
