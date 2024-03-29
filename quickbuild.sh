#!/bin/bash

set -e
directory=$(mktemp -d)
cd $directory
git clone $CIRCLE_REPOSITORY_URL
cd "$(basename "$CIRCLE_REPOSITORY_URL" .git)"
git checkout ${CIRCLE_BRANCH:=main}
docker-compose build
echo "$DOCKERHUB_ACCESS_TOKEN" | docker login --username "$DOCKERHUB_USERNAME" --password-stdin
docker-compose push
rm -rf $directory