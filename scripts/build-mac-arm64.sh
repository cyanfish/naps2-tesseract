#!/bin/bash

set -e

SCRIPTS_DIR="$( dirname -- "$0"; )"
BASE_DIR="$SCRIPTS_DIR/.."
SOURCES_DIR="$BASE_DIR/sources"
ARTIFACTS_DIR="$BASE_DIR/artifacts"

TARGET_DIR="$ARTIFACTS_DIR/mac-arm64"

pushd "$SOURCES_DIR/tesseract"
rm -rf build
mkdir build
pushd "build"
cmake .. -G"Unix Makefiles" -DDISABLED_LEGACY_ENGINE=ON -DBUILD_TRAINING_TOOLS=OFF -DBUILD_SHARED_LIBS=OFF -DDISABLE_CURL=ON -DDISABLE_ARCHIVE=ON -DGRAPHICS_DISABLED=ON -DENABLE_LTO=ON
cmake --build .
make
popd
popd

# TODO: Maybe build our own leptonica

cp "$SOURCES_DIR/tesseract/build/bin/tesseract" "$TARGET_DIR/tesseract"
cp "$SOURCES_DIR/tesseract/AUTHORS" "$TARGET_DIR/../tesseract-authors.txt"