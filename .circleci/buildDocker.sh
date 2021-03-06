#!/usr/bin/env bash

# Exit script if you try to use an uninitialized variable.
set -o nounset

# Exit script if a statement returns a non-true return value.
set -o errexit

# Use the error status of the first failure, rather than that of the last item in a pipeline.
set -o pipefail
cd ./applications
ROOT_DIR=$(pwd)
while read -r line ; do
  echo "Processing $line"
  # your code goes here
  TAG=$(echo $line | cut -f2 -d ' ' )

  APP_NAME=$(echo $TAG | cut -f1 -d@)
  VERSION=$(echo $TAG | cut -f2 -d@)
  if [ -n "$APP_NAME" ]; then
    DOCKER_TAG=$APP_NAME-$VERSION
    DIRECTORY=./$APP_NAME

    cd $DIRECTORY && {
        docker build -t palsson/monotest:prod-$DOCKER_TAG .
        docker tag $(docker images -q palsson/monotest:prod-$DOCKER_TAG) palsson/monotest:$APP_NAME-dev
        docker tag $(docker images -q palsson/monotest:prod-$DOCKER_TAG) palsson/monotest:$APP_NAME-latest
        docker login -u $DOCKER_USER -p $DOCKER_PASS
        docker push palsson/monotest:prod-$DOCKER_TAG
        docker push palsson/monotest:$APP_NAME-dev
        docker push palsson/monotest:$APP_NAME-latest

        cd $ROOT_DIR
    }
  fi
done < <(git log --grep='ci(release)' --max-count=1 | grep -)

