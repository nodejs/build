#!/bin/bash

## This script is designed to be enabled in /etc/sudoers for the `iojs` user,
## the only privileged access that user has to Docker.
## Since there is considerable access given by selecting arbitrary images and
## execution commands, there are still security concerns and additions of new
## images and changes to existing ones as well as the Bash that's executed
## inside them should be monitored for malicious activity.

set -e

OPTIND=1
image_base="rvagg/node-ci-containers"
image_tag=
exec_script="node-ci-exec.sh"

while getopts "i:" opt; do
    case "$opt" in
    i)
        if [[ "$OPTARG" =~ ^[a-zA-Z0-9_-]+$ ]]; then
          image_tag=$OPTARG
        else
          echo "Bad -i value"
          exit 1
        fi
        ;;
    *)
        echo "Wut?"
        exit 1
    esac
done

if test "$image_tag" = ""; then
  echo "Did not provide the docker image [-i]"
  exit 1
fi

if [ ! -f "$(pwd)/$exec_script" ]; then
  echo "Did not provide a node-ci-exec.sh script"
  exit 1
fi

set -x

image="${image_base}:${image_tag}"
# failure to pull is acceptable if Docker Hub is offline or erroring and we have the image
docker pull "${image}" || true
#docker run \
#  --init \
#  -e TINI_SUBREAPER=true \
#  -e TINI_KILL_PROCESS_GROUP=true \
#  -e TINI_VERBOSITY=3 \
#  --rm \
#  -v $(pwd):/home/iojs/workspace \
#  -v /home/iojs/.ccache/${image_tag}:/home/iojs/.ccache \
#  -u iojs \
#  "${image}" \
#  /bin/sh -xec "cd /home/iojs/workspace && . ./$exec_script"

container=$(docker run \
  --init \
  --rm \
  -d \
  -v $(pwd):/home/iojs/workspace \
  -v /home/iojs/.ccache/${image_tag}:/home/iojs/.ccache \
  -u iojs \
  "${image}" \
  tail -f /dev/null)

sleep 2

echo -e "Container is running ($image_tag)...\n"
docker exec $container /bin/sh -c "cat /etc/os-release || true"
echo -e "\n"

set +e
docker exec -i $container /bin/bash -xec "cd /home/iojs/workspace && . ./$exec_script"
exit_code=$?

docker stop $container

exit $exit_code
