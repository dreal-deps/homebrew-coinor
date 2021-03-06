#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

ID=$1
PASSWORD=$2
FORMULA_NAME=$3
VERSION=$4
case `uname -r` in
  14.*)
    OSX_NAME="yosemite"
    ;;
  15.*)
    OSX_NAME="el_capitan"
    ;;
  16.*)
    OSX_NAME="sierra"
    ;;
  17.*)
    OSX_NAME="high_sierra"
    ;;
  18.*)
    OSX_NAME="mojave"
    ;;
  *)
    OSX_NAME="unknown"
    ;;
esac

BOTTLE_FILENAME=${FORMULA_NAME}-${VERSION}.${OSX_NAME}.bottle.tar.gz
BINTRAY_URL=https://api.bintray.com/content/dreal/homebrew-coinor/${FORMULA_NAME}

if [ -e ${BOTTLE_FILENAME} ]
then
  # Upload Files
  curl -T ${BOTTLE_FILENAME} -u${ID}:${PASSWORD} ${BINTRAY_URL}/${VERSION}/${BOTTLE_FILENAME}
  # Publish version
  curl -X POST -u${ID}:${PASSWORD} ${BINTRAY_URL}/${VERSION}/publish
  # Remove the bottle
  rm -v ${BOTTLE_FILENAME}
else
  echo "File not found: ${BOTTLE_FILENAME}"
fi
