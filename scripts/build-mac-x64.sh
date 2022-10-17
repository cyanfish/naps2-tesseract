#!/bin/bash

set -e

SCRIPTS_DIR="$( dirname -- "$0"; )"
BASE_DIR="$SCRIPTS_DIR/.."
SOURCES_DIR="$BASE_DIR/sources"
ARTIFACTS_DIR="$BASE_DIR/artifacts"

TARGET_DIR="$ARTIFACTS_DIR/mac-x64"

pushd "$SOURCES_DIR/tesseract"
rm -rf build
mkdir build
pushd "build"
cmake .. -G"Unix Makefiles" -DDISABLED_LEGACY_ENGINE=ON -DBUILD_TRAINING_TOOLS=OFF -DBUILD_SHARED_LIBS=OFF -DDISABLE_CURL=ON -DDISABLE_ARCHIVE=ON -DGRAPHICS_DISABLED=ON -DENABLE_LTO=ON -DCMAKE_OSX_ARCHITECTURES=x86_64 -DCMAKE_SYSTEM_PROCESSOR=AMD64
cmake --build .
popd
popd

# Note: Had to install Homebrew and leptonica x64 and uninstall leptonica arm64
# See https://gist.github.com/progrium/b286cd8c82ce0825b2eb3b0b3a0720a0#homebrew
# I also couldn't figure out how to successfully set CMAKE_SYSTEM_PROCESSOR so I manually changed it in CMakeLists.txt
# Also added "-arch x86_64" manually to CMAKE_CXX_FLAGS_RELEASE after -Wno-unused-command-line-argument

# TODO: Maybe build our own leptonica

cp "$SOURCES_DIR/tesseract/build/bin/tesseract" "$TARGET_DIR/tesseract"
cp "$SOURCES_DIR/tesseract/AUTHORS" "$TARGET_DIR/../tesseract-authors.txt"