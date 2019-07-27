#!/bin/bash

set -e
directory=$(mktemp -d)
cd $directory
git clone $CIRCLE_REPOSITORY_URL
cd "$(basename "$CIRCLE_REPOSITORY_URL" .git)"
docker-compose build
echo "$DOCKERHUB_PASSWORD" | docker login --username "$DOCKERHUB_USERNAME" --password-stdin
docker-compose push
rm -rf $directory