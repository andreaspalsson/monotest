#!/usr/bin/env bash

# Exit script if you try to use an uninitialized variable.
set -o nounset

# Exit script if a statement returns a non-true return value.
set -o errexit

# Use the error status of the first failure, rather than that of the last item in a pipeline.
set -o pipefail

APP_NAME=$(echo $CIRCLE_TAG | cut -f1 -d@)
VERSION=$(echo $CIRCLE_TAG | cut -f2 -d@)
DOCKER_TAG=$APP_NAME-$VERSION
DIRECTORY=./applications/$APP_NAME
pwd
if [ -d "$DIRECTORY" ]; then
  # Control will enter here if $DIRECTORY exists.
  cd $DIRECTORY
  pwd

  docker build -t palsson/monotest:prod-$DOCKER_TAG .
  docker tag $(docker images -q palsson/monotest:prod-$DOCKER_TAG) palsson/monotest:$APP_NAME-dev
  docker tag $(docker images -q palsson/monotest:prod-$DOCKER_TAG) palsson/monotest:$APP_NAME-latest
  docker login -u $DOCKER_USER -p $DOCKER_PASS
  docker push palsson/monotest:prod-$DOCKER_TAG
  docker push palsson/monotest:$APP_NAME-dev
  docker push palsson/monotest:$APP_NAME-latest
fi