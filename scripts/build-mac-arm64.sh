#!/bin/bash

set -e

SCRIPTS_DIR="$( dirname -- "$0"; )"
BASE_DIR="$SCRIPTS_DIR/.."
SOURCES_DIR="$BASE_DIR/sources"
ARTIFACTS_DIR="$BASE_DIR/artifacts"

TARGET_DIR="$ARTIFACTS_DIR/mac-arm64"

pushd "$SOURCES_DIR/leptonica"
rm -rf build
mkdir build
pushd "build"
cmake .. -G"Unix Makefiles" -DBUILD_SHARED_LIBS=OFF \
    -DJPEG_LIBRARY="/opt/homebrew/lib/libjpeg.a" -DJPEG_INCLUDE_DIR="/opt/homebrew/include/" \
    -DPNG_LIBRARY="/opt/homebrew/lib/libpng16.a" -DPNG_INCLUDE_DIR="/opt/homebrew/include/libpng16/" \
    -DZLIB_LIBRARY="/opt/homebrew/opt/zlib/lib/libz.a" -DZLIB_INCLUDE_DIR="/opt/homebrew/opt/zlib/include/"
cmake --build .
sudo cmake --install .
popd
popd

pushd "$SOURCES_DIR/tesseract"
rm -rf build
mkdir build
pushd "build"
cmake .. -G"Unix Makefiles" \
    -DDISABLED_LEGACY_ENGINE=ON -DBUILD_TRAINING_TOOLS=OFF -DBUILD_SHARED_LIBS=OFF \
    -DDISABLE_CURL=ON -DDISABLE_ARCHIVE=ON -DGRAPHICS_DISABLED=ON -DENABLE_LTO=ON
cmake --build .
popd
popd

# Note: Had to manually remove gif, tiff, etc. (everything but jpeg/png/zlib) from leptonica CMakeLists
# TODO: Use -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 for all builds

cp "$SOURCES_DIR/tesseract/build/bin/tesseract" "$TARGET_DIR/tesseract"
cp "$SOURCES_DIR/tesseract/AUTHORS" "$TARGET_DIR/../tesseract-authors.txt"