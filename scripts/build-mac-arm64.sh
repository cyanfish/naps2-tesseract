#!/bin/bash

set -e

SCRIPTS_DIR="$( dirname -- "$0"; )"
BASE_DIR="$SCRIPTS_DIR/.."
SOURCES_DIR="$BASE_DIR/sources"
ARTIFACTS_DIR="$BASE_DIR/artifacts"

TARGET_DIR="$ARTIFACTS_DIR/mac-arm64"

pushd "$SOURCES_DIR/libjpeg-turbo"
rm -rf build
mkdir build
pushd "build"
cmake .. -G"Unix Makefiles" -DBUILD_SHARED_LIBS=OFF -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 -DWITH_JPEG8=1
cmake --build .
popd
popd

pushd "$SOURCES_DIR/zlib"
rm -rf build
mkdir build
pushd "build"
cmake .. -G"Unix Makefiles" -DBUILD_SHARED_LIBS=OFF -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15
cmake --build .
popd
popd

pushd "$SOURCES_DIR/libpng"
rm -rf build
mkdir build
pushd "build"
cmake .. -G"Unix Makefiles" -DBUILD_SHARED_LIBS=OFF -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 \
    -DPNG_BUILD_ZLIB=ON -DZLIB_LIBRARIES="$( realpath "../../zlib/build/libz.a"; )"
cmake --build .
popd
popd

pushd "$SOURCES_DIR/leptonica"
rm -rf build
mkdir build
pushd "build"
cmake .. -G"Unix Makefiles" -DBUILD_SHARED_LIBS=OFF -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 \
    -DJPEG_LIBRARY="$( realpath "../../libjpeg-turbo/build/libjpeg.a"; )" -DJPEG_INCLUDE_DIR="$( realpath "../../libjpeg-turbo/"; );$( realpath "../../libjpeg-turbo/build/"; )" \
    -DPNG_LIBRARY="$( realpath "../../libpng/build/libpng16.a"; )" -DPNG_INCLUDE_DIR="$( realpath "../../libpng/build/"; )" \
    -DZLIB_LIBRARY="$( realpath "../../zlib/build/libz.a"; )" -DZLIB_INCLUDE_DIR="$( realpath "../../zlib/build/"; )"
cmake --build .
popd
popd

pushd "$SOURCES_DIR/tesseract"
rm -rf build
mkdir build
pushd "build"
cmake .. -G"Unix Makefiles" -DCMAKE_OSX_DEPLOYMENT_TARGET=10.15 \
    -DDISABLED_LEGACY_ENGINE=ON -DBUILD_TRAINING_TOOLS=OFF -DBUILD_SHARED_LIBS=OFF \
    -DDISABLE_CURL=ON -DDISABLE_ARCHIVE=ON -DGRAPHICS_DISABLED=ON -DENABLE_LTO=ON \
    -DLeptonica_DIR="$( realpath "../../leptonica/build/"; )"
cmake --build .
popd
popd

# Note: Had to manually remove gif, tiff, etc. (everything but jpeg/png/zlib) from leptonica CMakeLists
# Brew dependencies: cmake coreutils

cp "$SOURCES_DIR/tesseract/build/bin/tesseract" "$TARGET_DIR/tesseract"
cp "$SOURCES_DIR/tesseract/AUTHORS" "$TARGET_DIR/../tesseract-authors.txt"